class Ryte::Setting::YamlLoader
  include ActiveModel::Validations

  BUNDLE_KEYS = %w(bundle_type settings)

  attr_accessor :file, :hash, :name, :settings

  validate :validate_settings

  def initialize(file)
    @file      = file
    @hash      = hash_from_file
    @name      = name_from_hash
    @settings  = []
  end

  def build!
    build
    commit
  end

  def build
    (hash || []).each do |key, bundle|
        build_settings(key, bundle)
      end
    return self
  end

  def commit
    if valid?
      Settings.all << settings
      Settings.list.save
      Settings.list(true)
    end
  end

  private

  def hash_from_file
    hash = YAML::load(file)
    hash ? hash.with_indifferent_access : hash
  end

  def name_from_hash
    hash.keys.first if hash
  end

  def build_settings(name, bundle)
    if bundle.try(:keys) == BUNDLE_KEYS
      (bundle[:settings] || []).each do |name, key_values|
        key_values.merge!(bundle: name, type: bundle[:bundle_type], name: name)
        settings << Ryte::Setting.new(key_values)
      end
    else
      errors.add(:hash, "Bundle #{name} contains invalid keys")
      return false
    end
  end

  def validate_settings
    settings.each do |setting|
      setting.valid?

      if setting.errors.count > 0
        setting.errors.messages.each do |key, error|
          errors.add(:settings, {key => error})
        end
      end
    end
  end
end
