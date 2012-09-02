require 'spec_helper'

describe Ryte::Setting::YamlLoader do

  before :each do
    @file_path = File.join(Rails.root, "spec", "support", "valid_settings.yml")
    @file = File.open(@file_path)
    Ryte::Setting::List.create
  end
  let(:loader) { Ryte::Setting::YamlLoader.new(@file) }

  describe 'constants' do

    it 'should have a ALLOWED_BUNDLE_KEYS_CONSTANT' do
      Ryte::Setting::YamlLoader::ALLOWED_BUNDLE_KEYS
    end

    it 'should have a REQUIRED_SETTINGS_KEYS' do
      Ryte::Setting::YamlLoader::REQUIRED_SETTINGS_KEYS
    end
  end

  describe 'accessors' do

    %w(file hash name settings).each do |attr|
      describe "#{attr}" do

        describe "readers" do

          before :each do
            loader.instance_variable_set("@#{attr}".to_sym, 1)
          end

          it "should have a reader" do
            loader.send(attr).should eql(1)
          end
        end

        describe "writers" do

          it "should have a writer" do
            loader.send("#{attr}=", 1)
            loader.send(attr).should eql(1)
          end
        end
      end
    end
  end

  describe 'initialize' do

    describe "file" do

      it "should set the file variable" do
        loader.file.should eql(@file)
      end
    end

    describe "hash" do
      it "should set the hash via 'hash_from_file'" do
        loader.hash == loader.send(:hash_from_file)
      end
    end

    describe "name" do

      it "should set the name via 'name_from_hash'" do
        loader.name == loader.send(:name_from_hash)
      end
    end

    describe "settings" do

      it "should set 'finalized' to an empty array" do
        loader.settings == []
      end
    end
  end

  describe "build!" do

    it "should call 'build!'" do
      loader.should_receive(:build)
      loader.build!
    end

    it "should call 'commit'" do
      loader.should_receive(:commit)
      loader.build!
    end
  end

  describe "build" do

    it "should call 'build_settings' on each hash bundle" do
      loader.hash.each do |key, bundle|
        loader.should_receive(:build_settings).with(key, bundle)
      end
      loader.build
    end

    it "return self" do
      loader.build.should be_an_instance_of(Ryte::Setting::YamlLoader)
    end
  end

  describe "commit" do

    before :each do
      @loader = loader.build
    end

    it "should persist settings to the databse" do
      Settings.all.count.should eql(0)
      @loader.commit
      Settings.all.count.should eql(3)
    end
  end

  describe "hash_from_file" do

    context "valid settings" do

      before :each do
        YAML.stub(:load).and_return({setting: true})
      end

      it "should return settings" do
        loader.send(:hash_from_file).keys.first.should eql("setting")
      end
    end

    context "invalid_settings" do

      before :each do
        YAML.stub(:load).and_return(false)
      end

      it "should return settings" do
        loader.send(:hash_from_file).should be_false
      end
    end
  end

  describe "name_from_hash" do

    context "settings" do

      it "should return the first key" do
        loader.send(:name_from_hash).should eql("beautiful_theme")
      end
    end

    context "settings are false" do

      before :each do
        @loader = loader
        @loader.stub!(:hash).and_return(false)
      end

      it "should return nil when settings is false" do
        @loader.send(:name_from_hash).should be_nil
      end
    end
  end

  describe "build_settings" do

    before :each do
      @loader = loader
      @name = "beautiful_theme"
      @bundle = loader.hash[@name]
    end

    context 'bundle provided' do

      context 'valid keys' do

        before :each do
          @loader.send(:build_settings, @name, @bundle)
          @first = @loader.settings.first
        end

        it "should build settings appropriately" do
          @first.name.should eql("username")
          @first.type.should eql(@bundle[:bundle_type])
          @first.value.should eql("incorvia")
        end
      end

      context 'bundle[:settings] is nil' do

        before :each do
          @bundle[:settings] = nil
          @loader.send(:build_settings, @name, @bundle)
        end

        it "should build no settings" do
          @loader.settings.count.should eql(0)
        end
      end

      context 'bundle.keys are invalid' do

        before :each do
          @bundle = {}
          @msg = ["Bundle beautiful_theme contains invalid keys"]
        end

        it "should add an error" do
          @loader.send(:build_settings, @name, @bundle)
          @loader.errors.messages[:hash].should eql(@msg)
        end

        it "should add an error" do
          @loader.send(:build_settings, @name, @bundle).should be_false
        end
      end
    end
  end

  describe "validate_settings" do

    it "should call'valid?' on each setting" do
      loader.build
      loader.settings.each do |setting|
        setting.should_receive(:valid?)
      end
      loader.send(:validate_settings)
    end

    describe 'errors' do

      before :each do
        @loader = loader
        @loader.build
        @loader.settings.first.name = nil
        @msg = [{:name=>["can't be blank", "is invalid"]}]
      end

      it 'should add errors when present' do
        @loader.send(:validate_settings)
        @loader.errors.messages[:settings].should eql(@msg)
      end
    end
  end
end
