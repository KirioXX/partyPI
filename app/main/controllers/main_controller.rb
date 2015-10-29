# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    before_action :require_login
    before_action :switchView

    def index
    end

    def switchView
      if !Volt.current_user
        redirect_to "/login"
      elsif isAdmin
        redirect_to "/admin"
      else
        redirect_to "/guest"
      end
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[2] == attrs.href.split('/')[2]
    end

    def isAdmin
      if Volt.current_user.admin.value && Volt.current_user.admin != nil
        page._isAdmin = true
        return true
      else
        page._isAdmin = false
        return false
      end
    end
  end
end
