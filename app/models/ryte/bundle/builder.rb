module Ryte::Bundle::Builder
  extend ActiveSupport::Concern

  def build!
    build; commit
  end

  def build
    (settings_hash || {}).each do |key, bundle|
      build_settings(key, bundle)
    end
    return self
  end

  def commit
    Settings.load(settings) if valid?
  end

  private

  def load_settings
    hash = YAML::load(settings_file)
    hash ? hash.with_indifferent_access : hash
  end

  def build_settings(name, bundle)
    if bundle.try(:[], :settings)
      bundle[:settings].each do |name, key_values|
        key_values.merge!(bundle: name, type: bundle[:bundle_type], name: name)
        settings << Ryte::Setting.new(key_values)
      end
    end
  end
end
