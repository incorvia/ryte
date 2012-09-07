require 'spec_helper'

describe Ryte::Bundle::Builder do

  let(:bundle) { Ryte::Bundle.new('default') }

  describe "build!" do

    it "should call 'build!'" do
      bundle.should_receive(:build)
      bundle.build!
    end

    it "should call 'commit'" do
      bundle.should_receive(:commit)
      bundle.build!
    end
  end

  describe "build" do

    it "should call 'build_settings' on each hash bundle" do
      bundle.settings_hash.each do |key, values|
        bundle.should_receive(:build_settings).with(key, values)
      end
      bundle.build
    end

    it "returns self" do
      bundle.build.should be_an_instance_of(Ryte::Bundle)
    end
  end

  describe "commit" do

    before :each do
      # Delete settings from env setup.
      Settings.all.where(name: "widget_width").first.delete
    end

    let(:built_bundle) { bundle.build }

    it "should persist settings to the databse" do
      expect {
        built_bundle.commit
      }.to change(Settings.all, :count).by(1)
    end
  end

  describe "build_settings" do

    let(:hash) { bundle.settings_hash['default'] }

    context 'bundle provided' do

      before :each do
        bundle.send(:build_settings, 'default', hash)
        @first = bundle.settings.first
      end

      it "should build settings appropriately" do
        @first.name.should eql("widget_width")
        @first.type.should eql(hash[:bundle_type])
        @first.value.should eql("50")
      end
    end

    context 'bundle[:settings] is nil' do

      before :each do
        @bundle = bundle
        hash[:settings] = nil
        @bundle.send(:build_settings, 'default', hash)
      end

      it "should build no settings" do
        @bundle.settings.count.should eql(0)
      end
    end
  end
end
