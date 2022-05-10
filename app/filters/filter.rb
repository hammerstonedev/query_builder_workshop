class Filter
	attr_accessor :blueprint
	
  def initialize(blueprint=nil)
    @blueprint = blueprint
	end

	def get_query
    # Let's build it! 
    if blueprint.present?
      initial_query.where(make_subquery)
    else
      initial_query
    end
	end

  def make_subquery
    subquery = nil
    blueprint.each_with_index do |criterion, index|
      next if criterion[:type] == "conjunction"
      query_method = if index == 0
        "and"
      else
        blueprint[index - 1][:word] == "and" ? "and" : "or"
      end
      arel_nodes = apply_condition(criterion)
      subquery = add_nodes_to_subquery(nodes: arel_nodes, query_method: query_method, subquery: subquery)
    end
    subquery
  end

  def add_nodes_to_subquery(nodes:, query_method:, subquery:)
    # If subquery does not have a value, it is equal to the first node 
    if subquery.blank?
      nodes 
    else
      # If it exists, add the new node to the chain
      subquery.send(query_method, nodes)
    end
  end

  def apply_condition(criterion)
    get_condition_for_criterion(criterion)&.apply(criterion[:input])
  end

  def get_condition_for_criterion(criterion)
    # Returns the object that matches the condition. The conditions are defined on the filter object, 
    # in this case ContactFilter.rb
    # This checks the id on the condition such as first_name
    selected_condition = conditions.find { |condition| condition.id == criterion[:condition_id] }

    # Set filter variable on condition
    selected_condition.set_filter(self)
  end


  def configuration
    # Provided to the front end
	  {
	    type: "Hammerstone",
	    class_name: self.class.name,
	    # blueprint: @blueprint,
	    conditions: conditions_to_array,
	    stable_id: to_optional_stable_id(Hammerstone::Refine::Stabilizers::UrlEncodedStabilizer)
	  }
	end

	 def state
	  {
	    type: self.class.name,
	    blueprint: blueprint
	  }.to_json
	end


 def to_optional_stable_id(stabilizer=nil)
    create_stable_id(stabilizer) if automatically_stabilize?
  end

  def create_stable_id(stabilizer=nil)
    make_stable_id_generator(stabilizer).new.to_stable_id(filter: self)
  end

  def make_stable_id_generator(stabilizer = nil)
    generator = stabilizer 
    if generator.blank?
      raise ArgumentError.new('No stable id class set. Set using the default_stable_id_generator method')
    end
    generator
  end

  def conditions_to_array
    return nil unless conditions
    # Set filter object on condition and return to_array
    conditions.map { |condition| instantiate_condition(condition) }.map(&:to_array)
  end

  def instantiate_condition(condition_class)
    condition_class.set_filter(self)
    condition_class
  end

  def self.from_state(state)
    klass = state[:type].constantize
    filter = klass.new(state[:blueprint])
  end
end