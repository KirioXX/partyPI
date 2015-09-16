user_collection = Volt.current_app.store._users

user_collection
  .create(name: 'Admin',
          email: 'admin@admin.com',
          password: 'admin@1511',
          is_admin: true
  )
  .then { |user| puts "Added user AdminUser. Name: #{user.name}, E-Maile: #{user.email}, Password: #{user.password}"}
  .fail { |error| puts "Failed to add AdminUser. #{error}"}
