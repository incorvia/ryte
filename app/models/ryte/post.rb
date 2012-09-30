class Ryte::Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Slug
  include ActiveModel::ForbiddenAttributesProtection
  include Rails.application.routes.url_helpers

  max_versions 5

  ALLOWED_STATUSES = %w(draft published)

  field :title, type: String, default: ""
  field :body,  type: String, default: ""
  field :status, type: String, default: ""

  slug :title

  validates :status, inclusion: ALLOWED_STATUSES

  default_scope order_by([:updated_at, :desc])

  ALLOWED_STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def url
    post_path(self)
  end
end
