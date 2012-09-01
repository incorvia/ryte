class Ryte::Setting::YamlLoader

  ALLOWED_BUNDLE_KEYS = %w(bundle_type settings)
  ALLOWED_BUNDLE_TYPES = %w(theme widget)
  REQUIRED_SETTINGS_KEYS = %w(value display)

  attr_reader :file, :finalized, :name, :type, :settings

  def initialize(file)
    @file = file
    @settings = YAML::load(file).with_indifferent_access
    @name = @settings.keys.first
    @finalized = []
  end

  def build(screen=true)
    if screen && valid?
      build_settings
    end
  end

  def build_settings
    settings.each do |key, bundle|
      build_setting(bundle)
    end
  end

  def build_setting(bundle)
    bundle[:settings].each do |name, key_values|
      key_values.merge!(bundle: name, type: bundle[:bundle_type], name: name)
      finalized << Ryte::Setting.new(key_values)
    end
  end

  def valid?
    settings.each do |key, bundle|
      validate_bundle(bundle)
    end
  end

  def validate_bundle(bundle)
    validate_all_keys(bundle)
    validate_bundle_type(bundle[:bundle_type])
  end

  def validate_all_keys(bundle)
    validate_bundle_keys(bundle.keys)
    validate_setting_keys(bundle[:settings])
  end

  def validate_bundle_keys(keys)
    validate_keys(keys, ALLOWED_BUNDLE_KEYS)
  end

  def validate_setting_keys(settings)
    settings.each do |key, key_values|
      validate_keys(key_values.keys, REQUIRED_SETTINGS_KEYS)
    end
  end

  def validate_keys(keys, valid_keys)
    unless keys.sort == valid_keys.sort
      raise "Keys are missing or invalid: #{keys}"
    end
    return true
  end

  def validate_bundle_type(type)
    unless ALLOWED_BUNDLE_TYPES.include?(type)
      raise "Bundle type is invalid: #{type}"
    end
    return true
  end
end
