require 'spec_helper'

describe Ryte::Setting::List do

  let(:list) { create(:ryte_setting_list) }
  let(:list_with_settings) { create(:list_with_settings) }

  describe "associations" do

    describe "settings" do

      let(:list_with_settings) { create(:list_with_settings) }

      before :each do
        @list = list_with_settings
      end

      it "should embed_many settings" do
        @list.settings.count > 0
      end
    end
  end

  describe "validations" do

    describe "#allow_one_list" do

      before :each do
        @valid = Ryte::Setting::List.create
      end

      context 'no list' do

        it "should only allow one list" do
         @valid.should have(0).errors
        end
      end

      context 'list' do

        before :each do
          @invalid = Ryte::Setting::List.create
        end

        it "should only allow one list" do
          @invalid.should have(1).errors
        end

        it "should contain a relevant error message" do
          @invalid.errors.full_messages.first.should eql("One allowed list document")
        end
      end
    end
  end

  describe ".list" do

    context '@_list set' do

      before :each do
        Ryte::Setting::List.instance_variable_set(:@_list, list)
      end

      context 'refresh' do

        it "should refresh from the database" do
          Ryte::Setting::List.should_receive(:first)
          Ryte::Setting::List.list(true)
        end
      end

      context 'memoized' do

        it "should return a list from an instance variable" do
          Ryte::Setting::List.should_not_receive(:first)
          Ryte::Setting::List.list
        end
      end
    end

    context '@_settings nil' do

      before :each do
        Ryte::Setting::List.instance_variable_set(:@_list, nil)
      end

      context 'refresh' do

        it "should refresh from the database" do
          Ryte::Setting::List.should_receive(:first)
          Ryte::Setting::List.list(true)
        end
      end

      context 'memoized' do

        it "should return a list from the database" do
          Ryte::Setting::List.should_receive(:first)
          Ryte::Setting::List.list
        end
      end
    end
  end

  describe '.by_name' do

    before :each do
      @list = list_with_settings
      @setting = @list.settings.first
    end

    it "should return a setting by name" do
      Ryte::Setting::List.by_name(@setting.name).should eql(@setting)
    end
  end

  describe '.by_bundle' do

    before :each do
      @list = list_with_settings
      @setting = @list.settings.first
      @invalid = @list.settings.last
      @invalid.update_attributes(bundle: 'invalid')
    end

    it "should return a setting by name" do
      Ryte::Setting::List.by_bundle(@setting.bundle).should include(@setting)
    end

    it "should not return a setting not in the bundle" do
      Ryte::Setting::List.by_bundle(@setting.bundle).should_not include(@invalid)
    end
  end

  describe '.by_type' do

    before :each do
      @list = list_with_settings
      @setting = @list.settings.first
      @invalid = @list.settings.last
      @invalid.update_attributes(type: 'system')
    end

    it "should return a setting by name" do
      Ryte::Setting::List.by_type(@setting.type).should include(@setting)
    end

    it "should not return a setting not in the type" do
      Ryte::Setting::List.by_type(@setting.type).should_not include(@invalid)
    end
  end
end
