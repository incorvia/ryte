module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(name, current=false)
      theme = Ryte::Theme.new(name)

      if theme.valid?
        theme.build!

        if current
          set_current_theme(theme.name)
        end
      end
    end

    def set_current_theme(name)
      current_theme = Settings.by_name("current_theme")

      if current_theme
        current_theme.value = name
        current_theme.save
      end
      Settings.list(true)
    end
  end
end
