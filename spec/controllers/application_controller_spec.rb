require 'spec_helper'

describe ApplicationController do

  describe "#set_view_paths" do

    before :each do
      Ryte::Setting::List.create
      setup_current_theme
    end

    it "should call prepend_view_path with theme_path" do
      controller.should_receive(:prepend_view_path).with(controller.send(:theme_path))
      controller.send(:set_view_paths)
    end
  end
end
