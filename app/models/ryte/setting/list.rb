class Ryte::Setting::List
  include Mongoid::Document

  embeds_many :settings, class_name: "Ryte::Setting"

  validate :allow_one_list

  class << self

    def list(refresh=false)
      if refresh
        self.first
      else
        @_list ||= self.first
      end
    end

    def all
      self.list.settings
    end

    def by_name(name)
      self.list.settings.where(name: name).first
    end

    def by_bundle(bundle)
      self.list.settings.where(bundle: bundle).to_a
    end

    def by_type(type)
      self.list.settings.where(type: type).to_a
    end
  end

  private

  def allow_one_list
    if Ryte::Setting::List.count >= 1 && !self.persisted?
      errors.add(:one_allowed, "list document")
    end
  end
end
