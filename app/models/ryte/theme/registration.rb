module Ryte::Theme::Registration
  extend ActiveSupport::Concern

  module ClassMethods

    def register!(name, current=false)
      theme = Ryte::Theme.new(name)

      if theme.valid?
        theme.build!
        precompile

        if current
          Settings.current_theme = theme.name
        end
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
      set_asset_paths

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

    def set_asset_paths
      Settings.assets_dirs.each { |dir| Rails.application.assets.append_path(dir) }
    end
  end
end
