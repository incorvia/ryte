require 'spec_helper'

describe Ryte::Bundle::Core do

  let(:bundle) { Ryte::Bundle.new('default') }

  before :each do
    @file_path = bundle.bundle_settings_file
    @file = File.open(@file_path)
  end

  describe 'accessors' do

    accessors = [:name, :files, :settings_file, :settings, :settings_hash]

    accessors.each do |attr|
      describe "#{attr}" do
        it "should have a reader and writer" do
          bundle.methods.should include("#{attr}=".to_sym)
          bundle.methods.should include("#{attr}".to_sym)
        end
      end
    end
  end

  describe 'initialize' do

    describe "name" do

      it "should set the name" do
        bundle.name.should eql('default')
      end
    end

    describe "files" do

      it "should set the files variable via the file_matcher" do
        bundle.files.should eql(Dir.glob(File.join(bundle.bundle_dir, "**/*.*")))
      end
    end

    describe "settings_file" do

      it "should be settings file" do
        bundle.settings_file.to_path.should match(/settings.yml/)
      end
    end

    describe "settings" do

      it "should be an empty array" do
        bundle.settings.should eql([])
      end
    end

    describe 'settings_hash' do

      it "should call 'load_settings'" do
        bundle.should_receive(:load_settings)
        bundle.send(:initialize, 'default')
      end
    end
  end

  describe 'bundle_files' do

    it 'should return a list of files in the directory' do
      sample = File.join(bundle.bundle_dir, 'settings.yml')
      bundle.bundle_files.should include(sample)
    end
  end

  describe 'bundle_dir' do

    it 'should be the correct directory' do
      d = File.join(Rails.root, 'spec', 'support',
                    'user', 'bundles', 'default', '/')
      bundle.bundle_dir.should eql(d)
    end
  end

  describe 'bundle_settings_files' do

    it 'should be the correct file' do
      f = bundle.bundle_settings_file
      f.should be_an_instance_of(File)
      f.path.should eql(File.join(bundle.bundle_dir, 'settings.yml'))
    end
  end

  describe "load_settings" do

    context 'settings' do

      before :each do
        YAML.stub(:load).and_return({setting: true})
      end

      it "should return settings" do
        bundle.load_settings.keys.first.should eql("setting")
      end
    end

    context 'no / invalid settings' do

      before :each do
        YAML.stub(:load).and_return(false)
      end

      it "should return settings" do
        bundle.load_settings.should eql({})
      end
    end
  end

  describe "to_type" do

    it "should return a downcased bundle type" do
      bundle.to_type.should eql('bundle')
    end
  end
end

