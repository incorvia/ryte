module Ryte::Theme::Precompiler

  class << self

    def _env
      @_env ||= Rails.application.assets
    end

    def _paths
      @_paths ||= Rails.application.config.assets.paths
    end

    def run!
      self.clean_paths
      self.append_paths
      self.precompile
    end

    def clean_paths
      _env.clear_paths
    end

    def append_paths
      _paths.each { |path| _env.append_path(path) }

      Settings.assets_dirs.each do |dir|
        _env.append_path(dir)
      end
    end

    # Taken from Sprockets
    def precompile(digest=nil)
      unless Rails.application.config.assets.enabled
        warn "Cannot precompile assets if sprockets is disabled. Please set config.assets.enabled to true"
        exit
      end

      # Ensure that action view is loaded and the appropriate
      # sprockets hooks get executed
      _ = ActionView::Base

      config = Rails.application.config
      config.assets.compile = true
      config.assets.digest  = digest unless digest.nil?
      config.assets.digests = {}

      # Inject current_theme_paths

      env      = Rails.application.assets
      target   = File.join(Rails.public_path, config.assets.prefix)

      compiler = Sprockets::StaticCompiler.new(env,
                                               target,
                                               config.assets.precompile,
                                               :manifest_path => config.assets.manifest,
                                               :digest => config.assets.digest,
                                               :manifest => digest.nil?)
      compiler.compile
    end
  end
end
