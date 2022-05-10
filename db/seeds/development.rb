puts "🌱 Generating development environment seeds."

# Basic user with team and workspace
puts
puts "### Setting up users ###"
puts
user = User.find_or_create_by(email: "test@example.com") do |user|
  user.first_name = "Example"
  user.last_name = "User"
  user.password = "password"
  user.password_confirmation = "password"
  user.time_zone = "Pacific Time (US & Canada)"
end

if user.current_team.nil?
  user.create_default_team
  user.save
end

puts
puts "You can sign into the #{user.current_team.name} account with the following credentials."
puts "Email: #{user.email}"
puts "Password: password"
puts

puts
puts "### Finished setting up users ###"
puts



require 'faker'
# Create a team called "Query Builder Team" in the UI and then run this seeds file. 
team = user.current_team
20.times do
  contact = Contact.find_or_create_by(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    team_id: team.id,
    pets: Faker::Number.number(digits: 2)
  )
  contact.save!
end
