module Ryte::Setup

  class << self

    def setup!
      Mongoid.purge!
      Ryte::Setting::List.create
      load_settings_yml
    end

    def load_settings_yml
      file   = File.open(Ryte::Config.settings_path)
      loader = Ryte::Setting::YamlLoader.new(file)
      loader.build_and_commit
    end
  end
end
