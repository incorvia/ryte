module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(current=false)
      if valid?
        load_settings(name)
        set_current_name if current
      end
    end

    def load_settings
      loader = Ryte::Setting::YamlLoader.new(settings_path(name))
    end

    def set_current_theme
      # Set current theme name
    end
  end
end
