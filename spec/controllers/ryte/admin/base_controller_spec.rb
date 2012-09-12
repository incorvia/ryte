require 'spec_helper'

describe Ryte::Admin::BaseController do

  describe 'filters' do

    it "should authenticate_admin" do
      @controller.should_receive(:authenticate_admin!)
      @controller.send(:authenticate_admin!)
    end
  end
end
