puts "🌱 Generating development environment seeds."
require 'faker'
# Create a team called "Query Builder Team" in the UI and then run this seeds file. 
team = Team.find_or_create_by(name: "Query Builder Team")
20.times do
  contact = Contact.find_or_create_by(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    team_id: team.id
  )
  contact.save!
end
