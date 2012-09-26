require 'spec_helper'

describe Ryte::Public::PostsController do

  describe "index" do

    describe "get" do

      before :each do
        2.times { create(:ryte_post) }
      end

      it "be successful" do
        get :index
        response.should be_successful
      end

      it "assign @posts" do
        get :index
        assigns[:posts].should =~ Ryte::Post.all.to_a
      end
    end
  end
end
