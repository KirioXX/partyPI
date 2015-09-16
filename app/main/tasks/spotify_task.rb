require 'json'
require 'rspotify'

class SpotifyTask < Volt::Task
    RSpotify.raw_response = true

    def search(term)
      JSON.parse(RSpotify::Track.search(term,limit: 10))
    end
end
