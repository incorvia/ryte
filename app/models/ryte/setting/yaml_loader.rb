class Ryte::Setting::YamlLoader

  ALLOWED_BUNDLE_KEYS = %w(bundle_type settings)
  REQUIRED_SETTINGS_KEYS = %w(value display)

  attr_reader :file, :finalized, :name, :type, :settings

  def initialize(file)
    @file = file
    @settings = load_settings
    @name = load_name
    @finalized = []
  end

  def load_settings
    settings = YAML::load(file)
    if settings
      settings = settings.with_indifferent_access
    end
    return settings
  end

  def load_name
    if settings
      return settings.keys.first
    end
  end

  def build_and_commit(screen=true)
    build(screen)
    commit
  end

  def build(screen=true)
    if screen && valid?
      build_settings
    end
    return self
  end

  def commit
    Settings.all << finalized
    Settings.list.save
    Settings.list(true)
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
    if settings
      settings.each do |key, bundle|
        validate_bundle(bundle)
      end
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
    unless Ryte::Setting::ALLOWED_TYPES.include?(type)
      raise "Bundle type is invalid: #{type}"
    end
    return true
  end
end
