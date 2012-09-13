class Ryte::Public::BaseController < ApplicationController
  layout 'public'

  before_filter :set_view_paths
  before_filter :set_asset_paths unless Rails.env.production?

  def set_view_paths
    prepend_view_path(Settings.current_views_path)
  end

  def set_asset_paths
    Ryte::Theme::Precompiler.load_paths
  end

  def template
    Settings.current_template(params[:action]).read
  end

  def render_template(opts={})
    render text: Braai::Template.new(template).render(opts), layout: true
  end
end
