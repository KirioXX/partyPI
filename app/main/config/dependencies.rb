# Specify which components you wish to include when
# the "home" component loads.

# bootstrap css framework
component 'bootstrap'

# a default theme for the bootstrap framework
component 'bootstrap_jumbotron_theme'

# provides templates for login, signup, and logout
component 'user_templates'

# Component for Admin Area
component 'admin'

# Component for Guest Area
component 'guest'

component 'font_awesome'

if Volt.env.development?
  component 'browser_irb'
end
