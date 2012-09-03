module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(name, current=false)
      theme = Ryte::Theme.new(name)

      if theme.valid?
        theme.build!

        if current
          Settings.current_theme = theme.name
        end
      end
    end
  end
end
