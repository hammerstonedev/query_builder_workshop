module Hammerstone::Refine::Conditions
  class TextCondition < Condition

    def component
      "text-condition"
    end

    def clauses 
      [
        Clause.new("eq", "Equals"),
        Clause.new("dne", "Doesn't Equal")
      ]
    end

    def apply_condition(input)
      value = input[:value]
      table = filter.table
      clause = input[:clause]

      case clause
      when "eq"
        apply_clause_equals(value, table)
      when "dne"
        apply_clause_doesnt_equal(value, table)
      end
    end

    def apply_clause_equals(value, table)
      table[attribute].eq(value)
    end

    def apply_clause_doesnt_equal(value, table)
      table[attribute].not_eq(value).or(table[attribute].eq(nil))
    end

  end
end