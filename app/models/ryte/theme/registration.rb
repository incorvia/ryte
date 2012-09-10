module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(name)
      theme = self.new(name)

      binding.pry
      if theme.valid?
        theme.build!
        theme.add_to_registered_themes
      end
    end

    def activate!(name)
      Ryte::Theme::Precompiler.run!
      Settings.current_theme = name
    end
  end

  def add_to_registered_themes
    setting = Settings.by_name('registered_themes')
    setting.value << self.name
    setting.save
  end
end
