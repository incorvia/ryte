require 'spec_helper'

describe Ryte::Admin::PostsController do

  let(:admin) { create(:ryte_admin) }

  before :each do
    @admin = admin
    sign_in(@admin)
  end

  describe 'index' do

    describe 'get' do

      it 'should be successful' do
        get :index
        response.should be_successful
      end
    end
  end

  describe 'new' do

    describe 'get' do

      it 'should be succesful' do
        get :new
        response.should be_successful
      end

      it "should assign a @post variable" do
        get :new
        assigns[:post].should be_an_instance_of(Ryte::Post)
      end
    end
  end
end
