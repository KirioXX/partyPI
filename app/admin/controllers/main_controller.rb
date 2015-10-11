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
          puts user_id.value
          track_id = get_random_track_id(user_id.value)
          puts track_id
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
      return users.value[r]._id
    end

    def get_random_track(user)
      tracks = user.tracks.all
      count = 0
      tracks.count.then{|i| count = i-1}
      r = 0
      if count > 0
        r = (0..count).to_a.sample
      end
      tracks.value[r].value
    end

    def next_track

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
