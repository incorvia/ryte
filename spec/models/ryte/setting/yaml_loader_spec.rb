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

  describe 'readers' do

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

  describe "build" do

    context "screen is true" do

      it "should call 'valid?'" do
        loader.should_receive(:valid?)
        loader.build(true)
      end

      context "settings are valid" do

        before( :each ) do
          loader.stub!(:valid?).and_return(true)
        end

        it "should call 'build_settings'" do
          loader.should_receive(:build_settings)
          loader.build(true)
        end
      end

      context "settings are invalid" do

        before( :each ) do
          loader.stub!(:valid?).and_return(false)
        end

        it "should not call 'build_settings'" do
          loader.should_not_receive(:build_settings)
          loader.build(true)
        end
      end
    end

    context "screen is false" do

      before( :each ) do
        loader.stub!(:screen).and_return(false)
      end

      it "should not call 'build_settings'" do
        loader.should_not_receive(:build_settings)
        loader.build(false)
      end
    end
  end

  describe "build_settings" do

    it "should call 'build_setting' on each bundle" do
      loader.settings.each do |key, bundle|
        loader.should_receive(:build_setting).with(bundle)
      end
      loader.build_settings
    end
  end
end
