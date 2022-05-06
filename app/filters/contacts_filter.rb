class ContactsFilter < Filter

  def initial_query
    Contact.all
  end

  def automatically_stabilize?
    true
  end

  def table
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
