module Hammerstone::Refine::Conditions
  class TextCondition 
    attr_accessor :id

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

    def component
      "text-condition"
    end

    def clauses 
      [
        Clause.new("eq", "Equals"),
        Clause.new("dne", "Doesn't Equal")
      ]
    end
  end
end