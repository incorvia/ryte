require 'spec_helper'

describe Ryte::Admin::PostsController do

  describe 'index' do

    describe 'get' do

      it 'should be successful' do
        get :index
        response.should be_successful
      end
    end
  end
end
