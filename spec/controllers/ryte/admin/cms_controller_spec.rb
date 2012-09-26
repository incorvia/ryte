require 'spec_helper'

describe Ryte::Admin::CmsController do

  describe 'dashboard' do

    let(:admin) { create(:ryte_admin) }

    describe "get" do

      before :each do
        sign_in(admin)
      end

      it "be successful" do
        get :dashboard
        response.should be_successful
      end
    end

    context 'signed in' do

      before :each do
        sign_in(admin)
      end

      it 'show a sign out link' do
        get :dashboard
        response.should contain("Sign Out")
      end
    end

    context 'signed out' do

      before :each do
        sign_out(admin)
      end

      it 'show a sign out link' do
        get :dashboard
        response.should redirect_to(new_admin_session_path)
      end
    end
  end
end
