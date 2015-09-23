module Admin
  class MainController < Volt::ModelController
    def index
      # Add code for when the index view is loaded
    end

    def users
      page._users = store.users.all
    end

    def about
      # Add code for when the about view is loaded
    end

    def createParty
      store
        ._parties
        .create(createAt: Time.now)
        .then{ flash._successes << "Let´s get the party started! \o/"}
        .fail{ flash._errors << "Da ist irgendet was schiefgegangen :/" }
    end

    private

    # the main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._controller and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end
  end
end
