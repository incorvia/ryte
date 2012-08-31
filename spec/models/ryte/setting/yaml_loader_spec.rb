require 'spec_helper'

describe Ryte::Setting::YamlLoader do

  valid_file = File.join(Rails.root, "spec", "support", "valid_settings.yml")
  let(:file) { File.open(valid_file) }
  let(:loader) { Ryte::Setting::YamlLoader.new(file) }


  describe 'constants' do

    it 'should have a ALLOWED_BUNDLE_KEYS_CONSTANT' do
      Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_KEYS
    end

    it 'should have a ALLOWED_BUNDLE_KEYS_CONSTANT' do
      Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_TYPES
    end

    it 'should have a REQUIRED_SETTINGS_KEYS' do
      Ryte::Setting::YamlLoader::REQUIRED_SETTINGS_KEYS
    end
  end

  describe 'accessors' do

    %w(file finalized name type settings).each do |attr|
      describe "#{attr}" do

        before( :each ) do
          loader.instance_variable_set("@#{attr}".to_sym, 1)
        end

        it "should have an accessor" do
          loader.send(attr).should eql(1)
        end
      end
    end
  end

  describe 'initialize' do

    describe "name" do

      it "should set the bundle name to the top level key" do
        loader.name == "beautiful_theme"
      end
    end

    describe "finalized" do 

      it "should set 'finalized' to an empty array" do
        loader.finalized == []
      end
    end
  end
end
