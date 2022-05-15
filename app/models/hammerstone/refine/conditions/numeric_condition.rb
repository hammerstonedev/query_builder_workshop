module Hammerstone::Refine::Conditions
  class NumericCondition < Condition

    def component
      "numeric-condition"
    end

    def clauses 
      [
        Clause.new("lt", "Less Than"),
        Clause.new("gt", "Greater Than")
      ]
    end

    def apply_condition(input)
      value = input[:value1]
      table = filter.table
      clause = input[:clause]

      # build out the Arel nodes for a  numeric condition less 
      # than, greater than
      # Hint 1: Arel::Predications.instance_methods
      # Hint 2: Look at text_condition.rb for the arel syntax
    end
  end
end