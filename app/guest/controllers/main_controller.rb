module Guest
  class MainController < Volt::ModelController
    before_action :only_logedin

    private
    #redirect if not an admin user
    def only_logedin
      if !Volt.current_user
        redirect_to '/login'
        stop_chain
      end
    end
  end
end
