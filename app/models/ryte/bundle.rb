class Ryte::Bundle
  include ActiveModel::Validations
  include Ryte::Bundle::Builder
  include Ryte::Bundle::Validations
  include Ryte::Bundle::Core
end

