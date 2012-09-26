require 'spec_helper'

describe Ryte::Setup do

  context 'environment has been setup' do

    it "create a Ryte::Setting::List" do
      Ryte::Setting::List.first.should_not be_nil
    end

    it "set Settings.list to the Ryte::Setting::List" do
      Ryte::Setting::List.first.should eql(Settings.list)
    end

    it "setup a default user" do
      Ryte::Admin.first.email.should eql('user@admin.org')
    end

    it "create a current_theme setting" do
      Settings.by_name("current_theme").value.should eql('default')
    end

    it "create a registered_themes setting" do
      Settings.by_name("registered_themes").value.should eql(['default'])
    end

    it "create a system_setup setting" do
      Settings.by_name("system_setup").value.should eql(true)
    end

    it "register the default theme" do
      Ryte::Theme.should_receive(:register!).with('default')
      Ryte::Setup.setup!(approve: false, feedback: false)
    end

    it "activate the default theme" do
      Ryte::Theme.should_receive(:activate!).with('default')
      Ryte::Setup.setup!(approve: false, feedback: false)
    end
  end
end
