module Ryte::Bundleable
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    include Ryte::Bundleable::Core_
    include Ryte::Bundleable::Builder_
    include Ryte::Bundleable::Validations_
  end
end
