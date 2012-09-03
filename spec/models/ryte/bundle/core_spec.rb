require 'spec_helper'

describe Ryte::Bundle::Core do

  let(:theme) { Ryte::Theme.new('default') }

  before :each do
    @file_path = File.join(Rails.root, "spec", "support", "valid_settings.yml")
    @file = File.open(@file_path)
    Ryte::Setting::List.create
  end

  describe 'accessors' do

    accessors = [:name,:settings,:files,:settings_hash,:settings_file]

    accessors.each do |attr|
      describe "#{attr}" do
        it "should have a reader and writer" do
          theme.methods.should include("#{attr}=".to_sym)
          theme.methods.should include("#{attr}".to_sym)
        end
      end
    end
  end

  describe 'initialize' do

    describe "name" do

      it "should set the name" do
        theme.name.should eql('default')
      end
    end

    describe "files" do

      it "should set the files variable via the file_matcher" do
        theme.files.should eql(Dir.glob(theme.file_matcher('default')))
      end
    end

    describe "settings_file" do

      it "should be settings file" do
        theme.settings_file.to_path.should match(/settings.yml/)
      end
    end

    describe "settings" do

      it "should be an empty array" do
        theme.settings.should eql([])
      end
    end

    context 'valid files' do

      before :each do
        @theme = theme
        @theme.stub!(:validate_files).and_return(true)
      end

      it "should call 'load_settings'" do
        @theme.should_receive(:load_settings)
        @theme.send(:initialize, 'default')
      end
    end

    context 'invalid files' do

      before :each do
        @theme = theme
        @theme.stub!(:validate_files).and_return(false)
      end

      it "should call 'load_settings'" do
        @theme.should_not_receive(:load_settings)
        @theme.send(:initialize, 'default')
      end
    end
  end
end

