require 'faker'
user_collection = Volt.current_app.store._users

#user_collection
#  .create(name: 'Admin',
#          email: 'admin@admin.com',
#          password: 'admin@1511',
#          admin: true,
#          image: Faker::Avatar.image
#  )
#  .then { |user| puts "Added user AdminUser. Name: #{user.name}, E-Maile: #{user.email}, Password: #{user.password}"}
#  .fail { |error| puts "Failed to add AdminUser. #{error}"}


10.times do |num|
  user_collection
    .create(name: Faker::Name.first_name,
            email: Faker::Internet.email,
            password: "pw@1511",
            image: Faker::Avatar.image,
    )
    .then { |user| puts "Added fake user. Name: #{user.name}, E-Maile: #{user.email}, Password: #{user.password}"}
    .fail { |error| puts "Failed to add AdminUser. #{error}"}
end
