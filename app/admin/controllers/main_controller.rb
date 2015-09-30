module Admin
  class MainController < Volt::ModelController
    before_action :admin_only

    def index
      page._party_tracks = store.parties.first.tracks.all
      page._party_guests = store.parties.first.users.all
    end

    def createParty
      if store.parties.first.values != nil
         store.parties.first.destroy
      end
        store
          ._parties
          .create(createAt: Time.now)
          .then{ flash._successes << "Let´s get the party started! \o/"}
          .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    def add_track_to_party
      if store.parties.first.tracks.count.value<11
        user = get_random_user
        store._parties.first._tracks.all.value << get_random_track(user)
      end
    end

    def get_random_user
      users = store.parties.first.users.all
      count = users.value.count.value - 1
      r = 0
      if count > 0
        r = (0..count).to_a.sample
      end
      return users.value[r].value
    end

    def get_random_track(user)
      tracks = user.tracks.all
      count = tracks.value.count.value - 1
      r = 0
      if count > 0
        r = (0..count).to_a.sample
      elsif count < 0
          # Kein Track vorhande
      end
      track = tracks.value[r].value
      return track
    end

    def next_track
      puts "Redy"
    end

    private

    # the main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._controller and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    #redirect if not an admin user
    def admin_only
      if !Volt.current_user.admin
        redirect_to '/login'
        stop_chain
      end
    end
  end
end
