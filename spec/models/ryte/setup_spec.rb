require 'spec_helper'

describe Ryte::Setup do

  let(:settings_yml) { File.open(Ryte::Config.settings_path) }
  let(:theme) { Ryte::Theme.new('default') }

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
  end
end
