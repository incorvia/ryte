require 'spec_helper'

describe Ryte::Bundle::Validations do

  let(:bundle) { Ryte::Bundle.new('default') }

  describe "constants" do

    [:BUNDLE_KEYS].each do |constant|
      describe "#{constant}" do

        it "should exist" do
          Ryte::Bundle.constants.should include(constant)
        end
      end
    end
  end

  describe "validations" do

    describe "validate_name" do

      before :each do
        @valid = %w(foo foo_bar _foo_bar_ foo1)
        @invalid = ['Foo','foo bar','foobar*']
      end

      context "valid" do

        it "should be valid" do
          @valid.each do |valid|
            bundle.name = valid
            bundle.send(:validate_name)
            bundle.errors.count.should eql(0)
          end
        end
      end

      context "invalid" do

        it "should be invalid" do
          @invalid.each do |invalid|
            bundle.name = invalid
            bundle.send(:validate_name)
            bundle.errors.count.should eql(1)
            bundle.errors.clear
          end
        end
      end
    end

    describe "validate_keys" do

      context "invalid keys" do

        it "should be invalid" do
          bundle.settings_hash[:default].delete("bundle_type")
          bundle.should_not be_valid
        end
      end
    end

    describe "validate_settings" do

      context "invalid settings" do

        before :each do
          @bundle = bundle
          @bundle.build
          @bundle.should be_valid
          @bundle.settings.first.name = nil
          @errors = [{:name=>["can't be blank", "is invalid"]}]
        end

        it "should be invalid" do
          @bundle.should_not be_valid
        end

        it "should have the correct error" do
          @bundle.valid?
          @bundle.errors.messages[:settings].should eql(@errors)
        end
      end
    end
  end

  describe "validate_settings" do

    it "should call'valid?' on each setting" do
      bundle.build
      bundle.settings.each do |setting|
        setting.should_receive(:valid?)
      end
      bundle.send(:validate_settings)
    end

    describe 'errors' do

      before :each do
        @bundle = bundle
        @bundle.build
        @bundle.settings.first.name = nil
        @msg = [{:name=>["can't be blank", "is invalid"]}]
      end

      it 'should add errors when present' do
        @bundle.send(:validate_settings)
        @bundle.errors.messages[:settings].should eql(@msg)
      end
    end
  end

  describe "missing_files" do

    before :each do
      stub_const("Ryte::Bundle::REQUIRED", ['foo.yml'])
      Ryte::Theme.stub!(:files).and_return([])
    end

    it 'should return missing files' do
      bundle.send(:missing_files).first.should match(/foo\.yml/)
    end
  end
end
