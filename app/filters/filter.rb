class Filter
	attr_accessor :blueprint
	
  def initialize(blueprint=nil)
    @blueprint = blueprint
	end

	def get_query
    # Let's build it! 
    # Example blueprint if first_name = colleen 
    # [{:depth=>1, :type=>"criterion", :condition_id=>"first_name", :input=>{:clause=>"eq", :value=>"colleen"}}]
    # byebug
    # puts table
    #<Arel::Table:0x0000000117b65f90 @name="contacts", @klass=Contact(id: integer, team_id: integer, email: string, first_name: string, last_name: string, created_at: datetime, updated_at: datetime), @type_caster=#<ActiveRecord::TypeCaster::Map:0x0000000117b65f40 @klass=Contact(id: integer, team_id: integer, email: string, first_name: string, last_name: string, created_at: datetime, updated_at: datetime)>, @table_alias=nil>
    # (byebug) table.class
    # Arel::Table
    # puts blueprint
    initial_query.where(make_subquery)
	end

  def make_subquery
    subquery = nil 
    blueprint.each do |criterion|
      column = criterion[:condition_id]
      next if criterion[:type] == "conjunction"
      case criterion[:input][:clause]
      when "eq"
        node = table[column].eq(criterion[:input][:value])
      when "dne"
        node = table[column].eq(criterion[:input][:value])
      end
      subquery = subquery&.and(node) || node
    end
    subquery
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