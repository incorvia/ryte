module Ryte::Setup

  class << self

    def setup!(opts={})
      defaults = {
        approve:   true,
        clean:     true,
        list:      true,
        settings:  true,
        theme:     true,
        feedback:  true,
        users:     true,
      }

      opts.reverse_merge!(defaults)

      approve = opts[:approve] ? seek_approval : 'yes'

      if approve == 'yes'
        clean_env       if opts[:clean]
        setup_settings  if opts[:settings]
        setup_users     if opts[:users]
        setup_theme     if opts[:theme]
        notify          if opts[:feedback]
      end
    end

    def seek_approval
      puts I18n.t 'setup.notices.approval'
      return gets.chomp
    end

    def notify
      puts I18n.t 'setup.notices.success'
    end

    def clean_env
      Mongoid.purge!
      Ryte::Setting::List.instance_variable_set(:@_list, nil)
    end

    def setup_settings
      settings = []
      settings << create_current_theme
      settings << create_registered_themes
      settings << system_setup_complete
      Settings.load(settings)
    end

    def create_current_theme
      values = {
        name: "current_theme",
        value: "default",
        display: "Default",
        bundle: "system",
        type: "system"
      }

      Ryte::Setting.new(values)
    end

    def create_registered_themes
      values = {
        name: "registered_themes",
        value: [],
        display: "Registered Themes",
        bundle: "system",
        type: "system"
      }

      Ryte::Setting.new(values)
    end

    def system_setup_complete
      values = {
        name: "system_setup",
        value: true,
        display: "System Setup",
        bundle: "system",
        type: "system"
      }

      Ryte::Setting.new(values)
    end

    def setup_users
      Ryte::Admin.create(email:  'user@admin.org',
                         password: 'password',
                         password_confirmation: 'password')
    end

    def setup_theme
      Ryte::Theme.register!('default')
      Ryte::Theme.activate!('default')
    end
  end
end
