require 'spec_helper'

describe Ryte::Post do

  let(:post) { build(:ryte_post) }

  describe "validations" do

    Ryte::Post::ALLOWED_STATUSES.each do |status|
      it "allows '#{status}' as a status" do
        post.status = status
        post.should be_valid
      end
    end

    it "dissallow not allowed statuses" do
      post.status = "foo"
      post.should_not be_valid
    end
  end

  Ryte::Post::ALLOWED_STATUSES.each do |status|
    describe "#{status}?" do

      it "returns true when status is appropriate" do
        post.status = status
        post.send("#{status}?").should be_true
      end

      it "returns false when inappropriate" do
        post.status = "foo"
        post.send("#{status}?").should be_false
      end
    end
  end

  describe "slugs" do

    it "responds to slug" do
      post.slug
    end
  end
end
