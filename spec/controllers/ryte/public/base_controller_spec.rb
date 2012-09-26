require 'spec_helper'

describe Ryte::Public::BaseController do

  describe "#set_view_paths" do

    it "call prepend_view_path with theme_path" do
      arg = Settings.current_views_path
      controller.should_receive(:prepend_view_path).with(arg)
      controller.send(:set_view_paths)
    end
  end

  describe "#set_asset_paths" do

    it "call load paths" do
      Ryte::Theme::Precompiler.should_receive(:load_paths)
      controller.send(:set_asset_paths)
    end
  end

  describe "#template" do

    before :each do
      controller.params = { action: 'index' }
      @res = controller.send(:template)
    end

    it "return the current actions template" do
      @res.should match(/Theme:\ Index/i)
    end
  end

  describe "render_template" do

    controller(Ryte::Public::PostsController) do
      layout 'public'
    end

    before :each do
      create(:ryte_post)
    end

    it "render the template" do
      get :index
      response.should contain('This is the body of a Ryte Post')
    end
  end
end
