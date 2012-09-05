require 'spec_helper'

describe Ryte::Bundle::Builder do

  let(:theme) { Ryte::Theme.new('default') }

  before :each do
    Ryte::Setting::List.create
  end

  describe "build!" do

    it "should call 'build!'" do
      theme.should_receive(:build)
      theme.build!
    end

    it "should call 'commit'" do
      theme.should_receive(:commit)
      theme.build!
    end
  end

  describe "build" do

    it "should call 'build_settings' on each hash bundle" do
      theme.settings_hash.each do |key, bundle|
        theme.should_receive(:build_settings).with(key, bundle)
      end
      theme.build
    end

    it "returns self" do
      theme.build.should be_an_instance_of(Ryte::Theme)
    end
  end

  describe "commit" do

    before :each do
      @theme = theme.build
    end

    it "should persist settings to the databse" do
      expect {
        binding.pry
        @theme.commit
      }.to change(Settings.all, :count).by(1)
    end
  end

  describe "load_settings" do

    before :each do
      YAML.stub(:load).and_return({setting: true})
    end

    it "should return settings" do
      theme.send(:load_settings).keys.first.should eql("setting")
    end
  end

  describe "build_settings" do

    before :each do
      @theme = theme
      @name = "default"
      @bundle = theme.settings_hash[@name]
    end

    context 'bundle provided' do

      before :each do
        @theme.send(:build_settings, @name, @bundle)
        @first = @theme.settings.first
      end

      it "should build settings appropriately" do
        @first.name.should eql("widget_width")
        @first.type.should eql(@bundle[:bundle_type])
        @first.value.should eql("50")
      end
    end

    context 'bundle[:settings] is nil' do

      before :each do
        @bundle[:settings] = nil
        @theme.send(:build_settings, @name, @bundle)
      end

      it "should build no settings" do
        @theme.settings.count.should eql(0)
      end
    end
  end
end
