module Ryte::Setup

  class << self

    def setup!
      if approve_from_user == 'yes'

        # Clean Database
        Mongoid.purge! unless Rails.env.test?

        # Clean stale memoization
        Settings.list(true)

        create_initial_list
        create_initial_settings
        default_theme_register
        default_theme_activate

        # Report to user
        notify
      end
    end

    def approve_from_user
      unless Rails.env.test?
        setup_notice = <<-END
            The system indicates it has not been setup.
            Would you like to run setup?  This will purge.
            Your database.  To accept, type "yes", anything
            else will cancel this action.
        END
        puts setup_notice

        value = gets.chomp
      end

      value = "yes" if Rails.env.test?
      return value
    end

    def notify
      unless Rails.env.test?
        notify = <<-END
          Your system has now been setup and is ready for use.
        END
        puts notify
      end
    end

    def create_initial_list
      Ryte::Setting::List.create
    end

    def create_initial_settings
      settings = []
      settings << create_current_theme
      settings << system_setup_complete
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

    def system_setup_complete
      Ryte::Setting.new(name: "system_setup",
        value: true,
        display: "System Setup",
        bundle: "system",
        type: "system")
    end
  end
end
