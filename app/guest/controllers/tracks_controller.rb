module Guest
  class TracksController < Volt::ModelController
    def index
      page._user_tracks = Volt.current_user.tracks.all
    end

    def search
      add_to_party
    end

    def search_tracks
      SpotifyTask.search(page._searchterm).then do |results|
          items = Array.new
          page._search_results_arr = Array.new
          results['tracks']['items'].each do |result|
            h = Hash.new
            h['id'] = result['id']
            h['name'] = result['name']
            h['length'] = result['duration_ms']
            h['artist'] = result['artists'].first['name']
            h['album'] = result['album']['name']
            h['img'] = result['album']['images'].first['url']
            h['url'] = result['preview_url']
            page._search_results_arr << h
            items << result['name']
          end
          page._search_results = items
      end.fail do |error|
          flash._errors << "Es wurde leider kein Titel für deine Anfrage gefunden. Versuch es doch noch einmal."
      end
    end

    def add_or_remove_track(index)
      if index.is_a? Integer
        track =  page._search_results_arr[index].to_h
        if in_playlist(track['id'])
          remove_track(track['id'])
        else
          add_track(track)
        end
      else
         remove_track(index)
      end
    end

    def add_track(track)
      store
        ._tracks
        .create(spotifyID: track['id'],name: track['name'],length: track['length'],artist: track['artist'],album: track['album'],imgUrl: track['img'],url: track['url'])
        .then{ flash._successes << "Yay, ein neuer Track!! :3"}
        .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    def remove_track(id)
      store
        ._tracks
        .where(spotifyID: id)
        .first.destroy
        .then{ flash._successes << "Der Track wurde von deiner Liste entfernt!"}
        .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    def in_playlist(id)
      track_ids = Array.new()
      Volt.current_user.tracks.all.each do |track|
        track_ids << track.spotifyID
      end
      return track_ids.include? id
    end

    def add_to_party
      if !Volt.current_user.party_id.nil?
        puts "Add to Party"
          store.
            _parties.first
            ._users.append(Volt.current_user)
            .then{ flash._notices << "Die Party kann los gehen :)" }
            .fail{ flash._errors << "Da ist was schiefgegangen :/"}
      else
          puts 'In party'
      end
    end
  end
end
