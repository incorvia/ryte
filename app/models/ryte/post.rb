class Ryte::Post
  include Mongoid::Document

  field :text, :type => String, :default => ""
end
