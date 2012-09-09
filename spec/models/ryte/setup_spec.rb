require 'spec_helper'

describe Ryte::Setup do

  context 'environment has been setup' do

    it "should create a Ryte::Setting::List" do
      Ryte::Setting::List.first.should_not be_nil
    end

    it "should set Settings.list to the Ryte::Setting::List" do
      Ryte::Setting::List.first.should eql(Settings.list)
    end

    it "should create a current_theme setting" do
      Settings.by_name("current_theme").value.should eql('default')
    end

    it "should create a registered_themes setting" do
      Settings.by_name("registered_themes").value.should eql(['default'])
    end

    it "should create a system_setup setting" do
      Settings.by_name("system_setup").value.should eql(true)
    end

    it "should register the default theme" do
      Ryte::Theme.should_receive(:register!).with('default')
      Ryte::Setup.setup!(approve: false, feedback: false)
    end

    it "should activate the default theme" do
      Ryte::Theme.should_receive(:activate!).with('default')
      Ryte::Setup.setup!(approve: false, feedback: false)
    end
  end
end
