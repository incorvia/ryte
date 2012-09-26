require 'spec_helper'

describe Ryte::Bundleable::Validations_ do

  class Mock
    include Ryte::Bundleable
  end

  let(:bundle) { Mock.new('default') }

  describe "validations" do

    describe "validate_name" do

      before :each do
        @valid = %w(foo foo_bar _foo_bar_ foo1)
        @invalid = ['Foo','foo bar','foobar*']
      end

      context "valid" do

        it "be valid" do
          @valid.each do |valid|
            bundle.name = valid
            bundle.send(:validate_name)
            bundle.errors.count.should eql(0)
          end
        end
      end

      context "invalid" do

        it "be invalid" do
          @invalid.each do |invalid|
            bundle.name = invalid
            bundle.send(:validate_name)
            bundle.errors.count.should eql(1)
            bundle.errors.clear
          end
        end
      end
    end

    describe "validate_files" do

      context 'missing files' do

        it "require files" do
          bundle.required_files.each do |file|
            bundle.stub!(:missing_files).and_return([file])
            bundle.should_not be_valid
          end
        end
      end

      context 'files present' do

        it 'not return any errors' do
          Mock.stub!(:missing_files).and_return([])
          bundle.should be_valid
        end
      end
    end

    describe "validate_keys" do

      context "invalid keys" do

        before :each do
          @keys = bundle.required_keys
        end

        it "require a specific keys" do
          @keys.each do |key|
            bundle.settings_hash[:default].delete(key)
            bundle.should_not be_valid
          end
        end
      end
    end

    describe "validate_settings" do

      before :each do
        @bundle = bundle
        @bundle.build
      end

      it "call 'valid?' on each setting" do
        @bundle.settings.each do |setting|
          setting.should_receive(:valid?)
        end
        @bundle.send(:validate_settings)
      end

      context "valid settings" do

        it "have no errors" do
          @bundle.valid?
          @bundle.errors.messages[:settings].should eql(nil)
        end
      end

      context "invalid settings" do

        before :each do
          @bundle.should be_valid
          @bundle.settings.first.name = nil
          @errors = [{:name=>["can't be blank", "is invalid"]}]
        end

        it "be invalid" do
          @bundle.should_not be_valid
        end

        it "have the correct error" do
          @bundle.valid?
          @bundle.errors.messages[:settings].should eql(@errors)
        end
      end
    end
  end

  describe "missing_files" do

    before :each do
      @bundle = bundle
      @bundle.required_files = ['foo.yml']
    end

    it 'returns missing files' do
      @bundle.send(:missing_files).first.should match(/foo\.yml/)
    end
  end
end
