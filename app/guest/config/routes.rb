# See https://github.com/voltrb/volt#routes for more info on routes
# Routes for guest Section
client '/playlist', controller: 'tracks', action: 'index'
client '/search', controller: 'tracks', action: 'search'
