require 'spec_helper'

describe Ryte::Bundle::Validations do

  let(:theme) { Ryte::Theme.new('default') }

  describe "constants" do

    [:BUNDLE_KEYS, :REQUIRED].each do |constant|
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
            theme.name = valid
            theme.send(:validate_name)
            theme.errors.count.should eql(0)
          end
        end
      end

      context "invalid" do

        it "should be invalid" do
          @invalid.each do |invalid|
            theme.name = invalid
            theme.send(:validate_name)
            theme.errors.count.should eql(1)
            theme.errors.clear
          end
        end
      end
    end

    describe "validate_keys" do

      context "invalid keys" do

        it "should be invalid" do
          theme.settings_hash[:default].delete("bundle_type")
          theme.should_not be_valid
        end
      end
    end

    describe "validate_settings" do

      context "invalid settings" do

        before :each do
          @theme = theme
          @theme.build
          @theme.should be_valid
          @theme.settings.first.name = nil
          @errors = [{:name=>["can't be blank", "is invalid"]}]
        end

        it "should be invalid" do
          @theme.should_not be_valid
        end

        it "should have the correct error" do
          @theme.valid?
          @theme.errors.messages[:settings].should eql(@errors)
        end
      end
    end
  end

  describe "validate_settings" do

    it "should call'valid?' on each setting" do
      theme.build
      theme.settings.each do |setting|
        setting.should_receive(:valid?)
      end
      theme.send(:validate_settings)
    end

    describe 'errors' do

      before :each do
        @theme = theme
        @theme.build
        @theme.settings.first.name = nil
        @msg = [{:name=>["can't be blank", "is invalid"]}]
      end

      it 'should add errors when present' do
        @theme.send(:validate_settings)
        @theme.errors.messages[:settings].should eql(@msg)
      end
    end
  end

  describe "missing_files" do

    before :each do
      stub_const("Ryte::Theme::REQUIRED", ['foo.yml'])
      Ryte::Theme.stub!(:files).and_return([])
    end

    it 'should return missing files' do
      theme.send(:missing_files).first.should match(/foo\.yml/)
    end
  end

  describe "return_errors" do

    before :each do
      @theme = theme
    end

    context 'errors' do

      before :each do
        @theme.stub_chain(:errors, :messages).and_return({foo: ['error']})
      end

      it 'should return false' do
        @theme.send(:return_errors, :foo).should be_false
      end
    end

    context 'no errors' do

      before :each do
        @theme.stub_chain(:errors, :messages).and_return({})
      end

      it 'should return true' do
        @theme.send(:return_errors, :foo).should be_true
      end
    end
  end
end
