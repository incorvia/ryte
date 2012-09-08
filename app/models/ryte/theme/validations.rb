module Ryte::Theme::Validations
  extend ActiveSupport::Concern

  included do
    REQUIRED = %w(
      settings.yml
      views/posts/index.html.erb
      stylesheets/styles.css
    )
  end
end
