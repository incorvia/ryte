class Ryte::Post
  include Mongoid::Document
  include ActiveModel::ForbiddenAttributesProtection

  field :body, type: String, default: ""
end
