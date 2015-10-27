module Admin
  class MainController < Volt::ModelController
    before_action :require_login
    before_action :admin_only

    @partyCount = 0

    def index
      self.model = store.parties.first
      store.parties.all.count.then do |res|
        @partyCount = res
      end

      if @partyCount > 0
        self.model.tracks.first.then do |track|
          page._track = track.url
          page._track_name = track.name
          page._track_album = track.album
          page._track_artist = track.artist
          page._track_image = track.imgUrl
        end
      end

      page._party_tracks = self.model.tracks.all
      page._party_guests = self.model.users.all
    end

    def add_track_to_party
      self.model.tracks.all.size.then do |tracks_cou|
        if tracks_cou < 11
          user_id = get_random_user_id
          get_random_track_and_add(user_id)
        end
      end
    end

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
      self.model.tracks.first.then do |track|
        page._track = track.url
        page._track_name = track.name
        page._track_album = track.album
        page._track_artist = track.artist
        page._track_image = track.imgUrl
      end
      `$(#{first_element}).find('#player').load();`
      `$(#{first_element}).find('#player').play();`
    end

    def newParty
      store
        .parties
        .create(createAt: Time.now)
        .then{
          flash._successes << "Let´s get the party started! \o/"
        }
        .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    def index_ready
      if @partyCount > 0
        page._party_exist = false
      else
        page._party_exist = true
      end

      `$(#{first_element}).find('.player').on('ended', function() {`
          next_track
        `});`

      `$(#{first_element}).find('#player').load();`
    end

    private

    #redirect if not an admin user
    def admin_only
      if !Volt.current_user.admin
        redirect_to '/login'
      end
    end
  end
end
