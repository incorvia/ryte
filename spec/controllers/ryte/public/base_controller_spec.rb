require 'spec_helper'

describe Ryte::Public::BaseController do

  describe "#set_view_paths" do

    it "should call prepend_view_path with theme_path" do
      arg = Settings.current_views_path
      controller.should_receive(:prepend_view_path).with(arg)
      controller.send(:set_view_paths)
    end
  end

  describe "#set_asset_paths" do

    it "should call load paths" do
      Ryte::Theme::Precompiler.should_receive(:load_paths)
      controller.send(:set_asset_paths)
    end
  end
end
