module Ryte::Admin::MenuHelper

  def menu_active_status(controller, action)
    if controller_name == controller && action_name == action
      return 'active'
    end
  end
end

