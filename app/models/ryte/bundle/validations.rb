module Ryte::Bundle::Validations
  extend ActiveSupport::Concern

  included do
    BUNDLE_KEYS = %w(bundle_type settings)
    REQUIRED = %w(
      settings.yml
      views/posts/index.html.erb
      stylesheets/styles.css
    )

    validate :validate_name
    validate :validate_files
    validate :validate_keys
    validate :validate_settings
  end

  private

  def validate_name
    unless name =~ Ryte::Setting::NAME_REGEX
      errors.add(:name, "Name is invalid")
    end
    return_errors(:name)
  end

  def validate_files
    unless missing_files.empty?
      errors.add(:files, "File list is incomplete")
    end
    return_errors(:files)
  end

  def validate_keys
    (settings_hash || {}).each do |key, bundle|
      unless bundle.try(:keys) == BUNDLE_KEYS
        errors.add(:settings_hash, "Bundle #{name} contains invalid keys")
      end
    end
    return_errors(:settings_hash)
  end

  def validate_settings
    settings.each do |setting|
      unless setting.valid?
        setting.errors.messages.each do |key, error|
          errors.add(:settings, {key => error})
        end
      end
    end
    return_errors(:settings)
  end

  def missing_files
    required = self.class::REQUIRED.map do |x|
      File.join(Settings.users_path, self.to_type, name, x)
    end
    return (required - files)
  end

  def return_errors(type)
    errors.messages[type].nil? ? true : false
  end
end
