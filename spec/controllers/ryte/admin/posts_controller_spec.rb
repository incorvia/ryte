require 'spec_helper'

describe Ryte::Admin::PostsController do

  let(:admin) { create(:ryte_admin) }
  let(:valid) { { post: build(:ryte_post).attributes.symbolize_keys } }

  before :each do
    @admin = admin
    sign_in(@admin)
  end

  describe 'index' do

    describe 'get' do

      it 'be successful' do
        get :index
        response.should be_successful
      end
    end
  end

  describe 'new' do

    describe 'get' do

      it 'be succesful' do
        get :new
        response.should be_successful
      end

      it "assign a @post variable" do
        get :new
        assigns[:post].should be_an_instance_of(Ryte::Post)
      end
    end
  end

  describe 'create' do

    context 'valid parameters' do

      it "creates a post" do
        expect {
          post :create, valid
        }.to change(Ryte::Post, :count).by(1)
      end

      it "redirects" do
        post :create, valid
        response.should redirect_to(edit_admin_post_path(Ryte::Post.first))
      end
    end
  end

  describe "redirect_by_status" do

    context 'draft' do

      it "redirects to the edit page" do
        valid[:post][:status] = "draft"
        post :create, valid
        response.should redirect_to(edit_admin_post_path(Ryte::Post.first))
      end

    end

    context "published" do

      it "redirects to the live url" do
        valid[:post][:status] = "published"
        post :create, valid
        response.should redirect_to(post_path(Ryte::Post.first))
      end
    end
  end
end
