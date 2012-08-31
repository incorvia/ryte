require 'spec_helper'

describe Ryte::Setting::YamlLoader do

  let(:file) { File.open(File.join(Rails.root, "spec", "support", "valid_settings.yml")) }
  let(:loader) { Ryte::Setting::YamlLoader.new(file) }


  describe 'constants' do

    it 'should have a ALLOWED_BUNDLE_KEYS_CONSTANT' do
      Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_KEYS
    end

    it 'should have a ALLOWED_BUNDLE_KEYS_CONSTANT' do
      Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_TYPES
    end
  end

  describe 'accessors' do

    %w(file bundle_name bundle_type loaders).each do |attr|
      describe "#{attr}" do

        before( :each ) do
          loader.instance_variable_set("@#{attr}".to_sym, 1)
        end

        it "should have an accessor" do
          loader.send(attr).should eql(1)
        end
      end
    end

    describe "bundle_name" do

      it "should set the bundle name to the top level key" do
        loader.bundle_name == "beautiful_theme"
      end
    end
  end

  describe "build" do

    it "shoud call 'build_bundle' on each bundle of settings" do
      %w(beautiful_theme wonderful_widget).each do |key|
        loader.should_receive(:build_bundle).with(loader.settings[key])
      end
      loader.build
    end
  end

  describe "build_bundle" do

    before( :each ) do
      @bundle_hash = loader.settings[:beautiful_theme]
    end

    it "should call 'validate_bundle_type' with the bundle type from loader" do
      loader.should_receive.(:validate_bundle_type).with(@bundle_hash[:bundle_type])
      loader.build_bundle(@bundle_hash)
    end

    it "should call 'build_setting' for each setting in a bundle group" do
      %w(username name).each do |key|
        loader.should_receive(:build_setting).
          with("theme", "beautiful_theme", key, @bundle_hash[:settings][key])
      end
      loader.build_bundle(@bundle_hash)
    end
  end
end
