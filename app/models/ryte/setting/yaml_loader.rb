class Ryte::Setting::YamlLoader
  ALLOWED_BUNDLE_KEYS = %w(bundle_type settings)
  ALLOWED_BUNDLE_TYPES = %w(theme)

  attr_accessor :file
  attr_reader :bundle_name
  attr_reader :bundle_type
  attr_reader :settings

  def initialize(file)
    @file = file
    @settings = YAML::load(file).with_indifferent_access
    @bundle_name = @settings.keys.first
  end

  def build
    settings.each do |key, bundle_hash|
      build_bundle(bundle_hash)
    end
  end

  def build_bundle(bundle_hash)
    validate_bundle_type(bundle_hash[:bundle_type])

    bundle_hash[:settings].each do |name, key_values|
      build_setting(bundle_type, bundle_name, name, key_values)
    end
  end

  def build_setting(bundle_type, bundle_name, name, key_values)
    key_values.merge!(bundle: bundle_name, type: bundle_type, name: name)
    Ryte::Setting.create!(key_values)
    #TODO: Handle setting creation with register function
  end

  private

  def validate_keys(valid_keys, keys)
    invalid_keys = (keys - valid_keys)

    unless invalid_keys.empty?
      raise "Invalid keys present #{invalid_keys}"
    end
    return true
  end

  def validate_bundle_type(name)
    unless ALLOWED_BUNDLE_TYPES.include?(name)
      raise "Invalid keys present #{invalid_keys}"
    end
    @bundle_type = name
    return true
  end
end
