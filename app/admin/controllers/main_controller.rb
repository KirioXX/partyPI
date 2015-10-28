module Admin
  class MainController < Volt::ModelController
    before_action :require_login
    before_action :admin_only

    def index
      self.model = store.parties.first
      if self.model != nil
        redirect_to '/admin/party/new'
      end
    end

    def party_tracks
      store.parties.first.tracks.all
    end

    def party_guests
      store.parties.first.users.all
    end

    def current_track
      store.parties.first.tracks.first
    end

    def current_track_url
      store.parties.first.tracks.first.then{|t| t.url}
    end

    def index_ready
      page._party_tracks = self.model.tracks.all
      page._party_guests = self.model.users.all

      `$(#{first_element}).find('.player').on('ended', function() {`
          next_track
      `});`

      `startPlayer(false);`
    end

    def add_track_to_party
      self.model.tracks.all.size.then do |tracks_cou|
        if tracks_cou < 11
          user_id = get_random_user_id
          get_random_track_and_add(user_id)
        end
      end
    end

    def get_random_track_and_add(user_id)
      page._party_guests.value.where(id: user_id).first.then do |user|
        user.tracks.all.then do |tracks|
          r = (0..(tracks.length.value-1)).to_a.sample
          i = 0
          tracks.each do |track|
            if i == r
              store
                .tracks
                .create(spotifyID: track.spotifyID,name: track.name,length: track.length,artist: track.artist,album: track.album,imgUrl: track.imgUrl,url: track.url)
                .then do |res|
                  store.parties.first.tracks.append(res)
                end.fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
            end
            i += 1
          end
        end
      end
    end

    def next_track
      self.model.tracks.first.destroy
      `startPlayer(true);`
      add_track_to_party
    end

    private

    def get_random_user_id
      r = 0
      stop = true
      while stop
        users = self.model.users.all
        users.count.then do |users_cou|
          if users_cou-1 > 0
            r = (0..users_cou-1).to_a.sample
          end
        end
        users.value[r].tracks.all.count.then do |i|
            stop = false if i > 0
        end

      end

      return users.value[r]._id.value
    end

    #redirect if not an admin user
    def admin_only
      if !Volt.current_user.admin
        redirect_to '/login'
      end
    end
  end
end
