module Ryte::Bundle::Core
  extend ActiveSupport::Concern

  included do
    attr_accessor :name, :files, :settings_file,
      :settings, :settings_hash
  end

  def initialize(name)
    @name          = name
    @files         = bundle_files
    @settings_file = bundle_settings_file
    @settings      = []
    @settings_hash = load_settings
  end

  def bundle_files
    Dir.glob(File.join(bundle_dir, "**/*.*"))
  end

  def bundle_dir
    File.join(Settings.users_path, self.to_type.pluralize, name, "/")
  end

  def bundle_settings_file
    File.open(File.join(bundle_dir, "settings.yml"))
  end

  def load_settings
    hash = YAML::load(settings_file) || {}
    hash.with_indifferent_access
  end

  def to_type
    self.class.name.demodulize.downcase
  end
end
