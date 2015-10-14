module Admin
  class MainController < Volt::ModelController
    before_action :admin_only

    def index
      partyCount = 0

      store.parties.all.count.then do |res|
        partyCount = res
      end

      if partyCount > 0
        page._party_exist = false
      else
        page._party_exist = true
      end

      page._party_tracks = store._parties.first._tracks.all
      page._party_guests = store._parties.first._users.all
    end

    def add_track_to_party
      store._parties.first._tracks.all.size.then do |tracks_cou|
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
        users = store.parties.first.users.all
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
              Volt.logger.info(track.name)
            end
            i += 1
          end
        end
      end
    end

    def next_track
      store.parties.first.tracks.first.destroy
      store.parties.first.tracks.first.then do |track|
        Volt.logger.info('next_track')
        page._track = track.url
        page._track_name = track.name
        page._track_album = track.album
        page._track_artist = track.artist
        page._track_image = track.imgUrl
      end
      `$(#{first_element}).find('#player').load();`
    end

    def newParty
      if store.parties.first.values != nil
         store.parties.first.destroy
      end
        store
          ._parties
          .create(createAt: Time.now)
          .then{
            flash._successes << "Let´s get the party started! \o/"
          }
          .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    def index_ready
      `$(#{first_element}).find('.player').on('ended', function() {`
          next_track
        `});`

        if page._track == nil
          store.parties.first.tracks.first.then do |track|
            page._track = track.url
            page._track_name = track.name
            page._track_album = track.album
            page._track_artist = track.artist
            page._track_image = track.imgUrl
          end
          `$(#{first_element}).find('#player').load();`
        else
          `$(#{first_element}).find('#player').load();`
        end
        loadPlayer
    end

    private

    #redirect if not an admin user
    def admin_only
      if !Volt.current_user.admin
        redirect_to '/login'
        stop_chain
      end
    end
  end
end
