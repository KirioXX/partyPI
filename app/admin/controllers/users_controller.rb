module Admin
  class UsersController < Volt::ModelController
    before_action :require_login
    before_action :check_admin

    def index
      page._users = store.users.all
    end

    def add_to_party(user_id)
      store.users.where(id: user_id).first.then do |user|
        store.parties.first.users.append(user)
      end.fail do |err|
        puts err
      end
    end

    private

      def check_admin
        if Volt.current_user.admin == true
            redirect_to "/"
            stop_chain
        end
      end

      def in_party(id)
        user_ids = Array.new()
        store.parties.first.users.all.each do |user|
          user_ids << user.id
        end
        return user_ids.include? id
      end
  end
end
