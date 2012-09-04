module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(name)
      theme = self.new(name)
      theme.build! if theme.valid?
    end

    def activate!(name)
      Ryte::Theme::Precompiler.run!
      Settings.current_theme = name
    end
  end
end
