require 'spec_helper'

describe Ryte::Admin::CmsController do

  describe 'dashboard' do

    let(:admin) { create(:ryte_admin) }

    context 'signed in' do

      before :each do
        sign_in(admin)
      end

      it 'should show a sign out link' do
        get :dashboard
        response.should contain("Sign Out")
      end
    end

    context 'signed out' do

      before :each do
        sign_out(admin)
      end

      it 'should show a sign out link' do
        get :dashboard
        response.should redirect_to(new_admin_session_path)
      end
    end
  end
end
