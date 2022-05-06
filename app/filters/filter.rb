class Filter
	attr_accessor :blueprint
	
  def initialize(blueprint=nil)
    @blueprint = blueprint
	end

	def get_query
    # Let's build it! 
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