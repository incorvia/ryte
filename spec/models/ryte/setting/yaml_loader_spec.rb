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

        before :each do
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

        before :each do
          loader.stub!(:valid?).and_return(true)
        end

        it "should call 'build_settings'" do
          loader.should_receive(:build_settings)
          loader.build(true)
        end
      end

      context "settings are invalid" do

        before :each do
          loader.stub!(:valid?).and_return(false)
        end

        it "should not call 'build_settings'" do
          loader.should_not_receive(:build_settings)
          loader.build(true)
        end
      end
    end

    context "screen is false" do

      before :each do
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
      loader.send(:build_settings)
    end
  end

  describe "build_setting" do

    before :each do
      @bundle = loader.settings[:beautiful_theme]
      loader.send(:build_setting, @bundle)
      @setting = loader.finalized.first
    end

    it "should add to finalized a properly built Ryte::Setting" do
      @setting.should be_an_instance_of(Ryte::Setting)
      @setting.value.should eql('incorvia')
      @setting.display.should eql('Twitter Name')
    end
  end

  describe "valid?" do

    it "should call validate_bundle on each bundle" do
      loader.settings.each do |key, bundle|
        loader.should_receive(:validate_bundle).with(bundle)
      end
      loader.valid?
    end
  end

  describe 'validate_bundle' do

    before :each do
      @bundle = loader.settings[:beautiful_theme]
    end

    it "should call 'validate_all_keys' on each set of bundle keys" do
      loader.should_receive(:validate_all_keys).with(@bundle)
      loader.validate_bundle(@bundle)
    end

    it "should call 'validate_bundle_type' on the type" do
      loader.should_receive(:validate_bundle_type).with(@bundle[:bundle_type])
      loader.validate_bundle(@bundle)
    end
  end

  describe 'validate_all_keys' do

    before :each do
      @bundle = loader.settings[:beautiful_theme]
    end

    it "should call 'validate_bundle_keys' on the set of bundle keys" do
      loader.should_receive(:validate_bundle_keys).with(@bundle.keys)
      loader.validate_all_keys(@bundle)
    end

    it "should call 'validate_setting_keys' on setting keys" do
      loader.should_receive(:validate_setting_keys).with(@bundle[:settings])
      loader.validate_all_keys(@bundle)
    end
  end

  describe "validate_bundle_keys" do

    before :each do
      @keys = loader.settings[:beautiful_theme].keys
    end

    it "should call 'validate_keys' on the argument keys" do
      loader.should_receive(:validate_keys).
        with(@keys, Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_KEYS)
      loader.validate_bundle_keys(@keys)
    end
  end

  describe "validate_setting_keys" do

    before :each do
      @settings = loader.settings[:beautiful_theme][:settings]
      @valid = Ryte::Setting::YamlLoader::REQUIRED_SETTINGS_KEYS
    end

    it "should call 'validate_keys' on each key_value pair" do
      @settings.each do |key, key_values|
        loader.should_receive(:validate_keys).with(key_values.keys, @valid)
      end
      loader.validate_setting_keys(@settings)
    end
  end

  describe "validate_keys" do

    before :each do
      @valid = ['test1','test2']
    end

    context 'valid keys' do

      before :each do
        @keys = ['test1', 'test2']
      end

      it "should return true" do
        loader.validate_keys(@keys, @valid).should be_true
      end
    end

    context 'invalid keys' do

      before :each do
        @keys = ['test10', 'test11', ['test1']]
      end

      it "should return true" do
        @keys.each do |keys|
          expect {
            loader.validate_keys(keys, @valid)
          }.to raise_error
        end
      end
    end
  end

  describe "validate_bundle_type" do

    before :each do
      @valid = Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_TYPES
    end

    context 'valid type' do

      before :each do
        @type = 'theme'
      end

      it "should return true" do
        loader.validate_bundle_type(@type).should be_true
      end
    end

    context 'invalid keys' do

      before :each do
        @type = 'bad'
      end

      it "should return true" do
        expect {
          loader.validate_bundle_type(@type, @valid)
        }.to raise_error
      end
    end
  end

end
