require 'spec_helper'

describe Ryte::Setup do

  let(:settings_yml) { File.open(Ryte::Config.settings_path) }
  let(:loader) { Ryte::Setting::YamlLoader.new(settings_yml) }

  describe ".setup!" do

    it "should purge the database" do
      Mongoid.should_receive(:purge!)
      Ryte::Setup.setup!
    end

    it "should create a Ryte::Setting::List" do
      expect {
        Ryte::Setup.setup!
      }.to change(Ryte::Setting::List, :count).by(1)
    end

    it "call 'load_settings_yml'" do
      Ryte::Setup.should_receive(:load_settings_yml)
      Ryte::Setup.setup!
    end
  end

  describe ".load_settings_yml" do

    before :each do
      @loader = loader
      Ryte::Setting::YamlLoader.stub!(:new).and_return(@loader)
    end

    it "should call 'build_and_commit'" do
      @loader.should_receive(:build_and_commit)
      Ryte::Setup.load_settings_yml
    end
  end
end
