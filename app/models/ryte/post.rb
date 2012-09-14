class Ryte::Post
  include Mongoid::Document
  include ActiveModel::ForbiddenAttributesProtection

  field :title, type: String, default: ""
  field :body,  type: String, default: ""
end
