module Ryte::Setup

  class << self

    def setup!
      Mongoid.purge!
      create_initial_list
      create_initial_settings
      default_theme_register
      default_theme_activate
    end

    def create_initial_list
      Ryte::Setting::List.create
    end

    def create_initial_settings
      settings = []
      settings << create_current_theme
      Settings.load(settings)
    end

    def default_theme_register
      Ryte::Theme.register!('default')
    end

    def default_theme_activate
      Ryte::Theme.activate!('default')
    end

    def create_current_theme
      Ryte::Setting.new(name: "current_theme",
        value: "default",
        display: "Default",
        bundle: "system",
        type: "system")
    end
  end
end
