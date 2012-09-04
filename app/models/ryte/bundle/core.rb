module Ryte::Bundle::Core
  extend ActiveSupport::Concern

  included do
    attr_accessor :name, :files, :settings_file,
      :settings, :settings_hash
  end

  def initialize(name)
    @name          = name
    @files         = Dir.glob(file_matcher(name))
    @settings_file = File.open(Settings.settings_path(self.to_type))
    @settings      = []

    if validate_files
      @settings_hash = load_settings
    end
  end

  def file_matcher(name)
    File.join(Settings.users_path, self.to_type, name, "**/*.*")
  end

  def to_type
    self.class.name.demodulize.downcase.pluralize
  end
end
