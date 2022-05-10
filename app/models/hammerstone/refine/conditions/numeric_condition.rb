module Hammerstone::Refine::Conditions
  class NumericCondition < Condition

    def component
      "numeric-condition"
    end

    def clauses 
      [
        Clause.new("lt", "Doesn't Equal"),
        Clause.new("gt", "Doesn't Equal")
      ]
    end

    def apply_condition(input)
      value = input[:value1]
      table = filter.table
      clause = input[:clause]

      case clause
      when "lt"
        apply_clause_less_than(value, table)
      when "gt"
        apply_clause_greater_than(value, table)
      end
    end

    def apply_clause_less_than(value, table)
      table[attribute].lt(value)
    end

    def apply_clause_greater_than(value, table)
      table[attribute].gt(value)
    end
  end
end