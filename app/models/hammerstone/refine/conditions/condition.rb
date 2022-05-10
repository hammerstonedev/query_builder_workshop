module Hammerstone::Refine::Conditions
  class Condition

    attr_accessor :id
    attr_reader :filter, :attribute

    def initialize(id)
      @id = id
      # Optimistically set attribute to the id
      @attribute = id
    end

    def set_filter(filter)
      @filter = filter
      self
    end

    def to_array
      {
        id: id,
        component: self.component,
        display: self.id,
        meta: {clauses: clauses.map(&:to_array)},
        refinements: []
      }
    end

    def apply(input) 
      apply_condition(input)
    end
  end
end