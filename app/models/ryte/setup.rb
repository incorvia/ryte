module Ryte::Setup

  class << self

    def setup!
      Mongoid.purge!
      create_initial_list
      create_initial_settings
      register_default_theme
    end

    def create_initial_list
      Ryte::Setting::List.create
    end

    def create_initial_settings
      settings = []
      settings << create_current_theme
      Settings.load(settings)
    end

    def register_default_theme
      Ryte::Theme.register!('default', true)
    end

    def create_current_theme
      Ryte::Setting.new(name: "current_theme",
        value: "default",
        display: "Default",
        bundle: "system",
        type: "theme")
    end
  end
end
