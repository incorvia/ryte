module Ryte::Theme::Core
  extend ActiveSupport::Concern

  def initialize(*args)
    super(*args)

    @required_files = %w(
      settings.yml
      views/index.html
      stylesheets/styles.css
    )
  end
end
