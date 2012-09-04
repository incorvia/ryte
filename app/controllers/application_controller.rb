class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_view_paths

  def set_view_paths
    prepend_view_path(Settings.current_views_path)
  end
end
