module Admin
  class PartiesController < Volt::ModelController

    def new
    end

    def newParty
      store
        .parties
        .create(createAt: Time.now)
        .then{
          redirect_to '/admin'
        }
        .fail{ flash._errors << "There wend something wrong :/" }
    end

    #redirect if not an admin user
    def admin_only
      if !Volt.current_user.admin
        redirect_to '/login'
      end
    end

  end
end
