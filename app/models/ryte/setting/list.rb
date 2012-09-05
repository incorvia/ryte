class Ryte::Setting::List
  include Mongoid::Document

  embeds_many :settings, class_name: "Ryte::Setting"

  validate :allow_one_list

  class << self

    def list(refresh=false)
      if refresh
        @_list = self.first
      else
        @_list ||= self.first || self.create
      end
    end

    def all
      self.list.settings
    end

    def by_name(name)
      self.list.settings.where(name: name).first
    end

    def by_bundle(bundle)
      self.list.settings.where(bundle: bundle).to_a
    end

    def by_type(type)
      self.list.settings.where(type: type).to_a
    end

    def save_and_reload
      Settings.list.save
      Settings.list(true)
    end

    def load(settings)
      self.all << settings
      self.list.save
      self.list(true)
    end
    def theme_settings_path(type)
      File.join(Settings.users_path, type, current_theme, 'settings.yml')
    end

    def users_path
      Ryte::Config.user_path
    end

    def assets_dirs
      %w(images stylesheets javascripts).map { |x| File.join(current_theme_path, x) }
    end

    def current_theme
      Settings.by_name("current_theme").value
    end

    def current_theme=(value)
      Settings.by_name("current_theme").value = value
      Settings.save_and_reload
    end

    def current_theme_path
      File.join(Settings.users_path,'themes',Settings.current_theme)
    end

    def current_views_path
      File.join(current_theme_path, "views")
    end
  end

  private

  def allow_one_list
    if Ryte::Setting::List.count >= 1 && !self.persisted?
      errors.add(:one_allowed, "list document")
    end
  end
end
