# See https://github.com/voltrb/volt#routes for more info on routes
client '/', action: 'switchView'

# Routes for admin Section
client '/admin', component: 'admin', action: 'index'
client '/admin/users', component: 'admin', controller: 'users', action: 'index'

# Routes for guest Section
client '/guest', component: 'guest', controller:'tracks', action: 'index'
client '/guest/search', component: 'guest', controller: 'tracks', action: 'search'

# Routes for login and signup, provided by user_templates component gem
client '/signup', component: 'user_templates', controller: 'signup'
client '/login', component: 'user_templates', controller: 'login', action: 'index'
client '/password_reset', component: 'user_templates', controller: 'password_reset', action: 'index'
client '/forgot', component: 'user_templates', controller: 'login', action: 'forgot'
client '/account', component: 'user_templates', controller: 'account', action: 'index'

# The main route, this should be last. It will match any params not
# previously matched.
client '/', {}
