class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_view_paths

  def set_view_paths
    prepend_view_path(theme_path)
  end

  def theme_path
    File.join(Ryte::Config.users_path,'themes',Settings.current_theme,'partials')
  end
end
