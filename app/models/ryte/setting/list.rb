class Ryte::Setting::List
  include Mongoid::Document

  embeds_many :settings, class_name: "Ryte::Setting"

  validate :allow_one_list

  class << self

    def list(refresh=false)
      if refresh
        @_list   = self.first || self.create
      else
        @_list ||= self.first || self.create
      end
    end

    def all
      self.list.settings
    end

    def reload
      Settings.list(true)
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

    def load(settings)
      self.list.settings << settings
      self.save_and_reload
    end

    def save_and_reload
      self.list.save
      self.reload
    end

    def users_path
      Ryte::Config.user_path
    end

    def assets_dirs
      %w(images stylesheets javascripts fonts).map { |x| File.join(current_theme_path, x) }
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

    def current_template_path(action)
      File.join(current_theme_path, "views", "#{action}.html")
    end

    def current_template(action)
      File.open(current_template_path(action))
    end
  end

  private

  def allow_one_list
    if Ryte::Setting::List.count >= 1 && !self.persisted?
      errors.add(:one_allowed, "list document")
    end
  end
end
