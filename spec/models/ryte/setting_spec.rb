require 'spec_helper'

describe Ryte::Setting do

  let(:setting) { build(:ryte_setting) }
  let(:list_with_settings) { create(:list_with_settings) }

  describe "associations" do

    describe "setting_list" do

      before( :each ) do
        @list = list_with_settings
        @setting = @list.settings.first
      end

      it "should be embedded in a Ryte::Setting::List obejct" do
        @setting.setting_list.should eql(@list)
      end
    end
  end

  describe "validations" do

    before( :each ) do
      @setting = setting
    end

    describe "presence" do

      %w(name bundle type).each do |attr|

        describe "#{attr}" do

          context "absent" do

            before( :each ) do
              @setting.send("#{attr}=", nil)
            end

            it "should be not be valid" do
              @setting.should_not be_valid
            end
          end

          context "present" do

            before( :each ) do
              @setting.send("#{attr}=", 'theme')
            end

            it "should be be valid" do
              @setting.should be_valid
            end
          end
        end
      end
    end

    describe "name" do

      describe "uniqueness" do

        context "setting" do

          before( :each ) do
            @list = list_with_settings
            @invalid = @list.settings.first
            @invalid.name= @list.settings.last.name
          end

          it "should require uniqueness by name" do
            @invalid.should_not be_valid
          end
        end

        context "no setting"
      end

      describe "format" do

        context 'valid format' do

          it "should allow valid formats" do
            @setting.name = "test_name"
            @setting.should be_valid
            @setting.name = "_test_name_2"
            @setting.should be_valid
          end
        end

        context 'invalid format' do

          it "should allow valid formats" do
            @setting.name = "Test_name"
            @setting.should_not be_valid
            @setting.name = "_test_Name_@"
            @setting.should_not be_valid
            @setting.name = "_test name"
            @setting.should_not be_valid
            @setting.name = "_test.name"
            @setting.should_not be_valid
          end
        end
      end
    end

    describe 'bundle' do

      describe "format" do

        context 'valid format' do

          it "should allow valid formats" do
            @setting.bundle = "test_name"
            @setting.should be_valid
            @setting.bundle = "_test_name_2"
            @setting.should be_valid
          end
        end

        context 'invalid format' do

          it "should allow valid formats" do
            @setting.bundle = "Test_bundle"
            @setting.should_not be_valid
            @setting.bundle = "_test_Name_@"
            @setting.should_not be_valid
            @setting.bundle = "_test bundle"
            @setting.should_not be_valid
            @setting.bundle = "_test.bundle"
            @setting.should_not be_valid
          end
        end
      end
    end

    describe 'type' do

      context 'inclusion' do

        before( :each ) do
          Ryte::Setting::ALLOWED_TYPES.should include(@setting.type)
        end

        it "should be valid" do
          @setting.should be_valid
        end
      end

      context 'exclusion' do

        before( :each ) do
          @setting.type = 'invalid'
        end

        it "should not be valid" do
          @setting.should_not be_valid
        end
      end
    end
  end

  describe "booleans" do

    before( :each ) do
      @setting = setting
    end

    Ryte::Setting::ALLOWED_TYPES.each do |type|
      describe "#{type}?" do

        context "is of type" do

          before( :each ) do
            @setting.type = type
          end

          it "should return " do
            @setting.send("#{type}?").should be_true
          end
        end

        context "is not of type" do

          before( :each ) do
            @setting.type = "invalid"
          end

          it "should return false" do
            @setting.send("#{type}?").should be_false
          end
        end
      end
    end
  end
end
