class ContactsFilter < Filter

  def initial_query
    Contact.all
  end

  def automatically_stabilize?
    true
  end

  def table
    # This is how you define the AREL table so you can build up nodes
    Contact.arel_table
  end

  def conditions
    [
      Hammerstone::Refine::Conditions::TextCondition.new("first_name"),
      Hammerstone::Refine::Conditions::TextCondition.new("last_name"),
      Hammerstone::Refine::Conditions::TextCondition.new("email"),
    ]
  end
end
