require 'spec_helper'

describe Ryte::Public::PostsController do

  describe "index" do

    before :each do
      2.times { create(:ryte_post) }
    end

    it "is successful" do
      get :index
      response.should be_successful
    end

    it "assigns @posts" do
      get :index
      assigns[:posts].should =~ Ryte::Post.all.to_a
    end

  end

  describe "show" do

    let(:post) { create(:ryte_post) }

    it "is successful" do
      get :show, id: post.id
      response.should be_successful
    end

    it "assigns @post" do
      get :show, id: post.id
      assigns[:post].should eql(Ryte::Post.first)
    end
  end
end
