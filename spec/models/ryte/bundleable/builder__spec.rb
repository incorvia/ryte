require 'spec_helper'

describe Ryte::Bundleable::Builder_ do

  class Mock
    include Ryte::Bundleable
  end

  let(:bundle) { Mock.new('default') }

  describe "build!" do

    it "call 'build!'" do
      bundle.should_receive(:build)
      bundle.build!
    end

    it "call 'commit'" do
      bundle.should_receive(:commit)
      bundle.build!
    end
  end

  describe "build" do

    it "call 'build_settings' on each hash bundle" do
      bundle.settings_hash.each do |key, values|
        bundle.should_receive(:build_settings).with(key, values)
      end
      bundle.build
    end

    it "returns self" do
      bundle.build.should be_an_instance_of(Mock)
    end
  end

  describe "build_settings" do

    let(:hash) { bundle.settings_hash['default'] }

    context 'bundle provided' do

      before :each do
        bundle.send(:build_settings, 'default', hash)
        @first = bundle.settings.first
      end

      it "build settings appropriately" do
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

      it "build no settings" do
        @bundle.settings.count.should eql(0)
      end
    end
  end
end
