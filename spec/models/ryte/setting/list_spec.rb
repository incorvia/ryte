require 'spec_helper'

describe Ryte::Setting::List do

  let(:list) { Settings.list }
  let(:list_with_settings) { build(:list_with_settings) }

  describe "associations" do

    describe "settings" do

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
        Ryte::Setting::List.delete_all
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
          @invalid.should have(1).errors_on(:one_allowed)
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
          Ryte::Setting::List.reload
        end

        context 'no list' do

          before :each do
            Ryte::Setting::List.delete_all
          end

          it "should create a new list" do
            Ryte::Setting::List.should_receive(:create)
            Ryte::Setting::List.reload
          end
        end
      end

      context 'memoized' do

        it "should return a list from an instance variable" do
          Ryte::Setting::List.should_not_receive(:first)
          Ryte::Setting::List.list
        end
      end
    end

    context '@_list nil' do

      before :each do
        Ryte::Setting::List.instance_variable_set(:@_list, nil)
      end

      context 'refresh' do

        it "should refresh from the database" do
          Ryte::Setting::List.should_receive(:first)
          Ryte::Setting::List.reload
        end
      end

      context 'memoized' do

        it "should return a list from the database" do
          Ryte::Setting::List.should_receive(:first)
          Ryte::Setting::List.list
        end
      end

      context 'no_list' do

        before :each do
          Ryte::Setting::List.delete_all
        end

        it "should create a new list" do
          Ryte::Setting::List.should_receive(:create)
          Ryte::Setting::List.list
        end
      end
    end
  end

  describe '.all' do

    it "should return all the settings" do
      Ryte::Setting::List.all.should =~ Settings.all
    end
  end

  describe '.reload' do

    it "should call 'list' with refresh set to true" do
      Settings.should_receive(:list).with(true)
      Ryte::Setting::List.reload
    end
  end

  describe '.by_name' do

    before :each do
      @setting = Settings.all.first
    end

    it "should return a setting by name" do
      Ryte::Setting::List.by_name(@setting.name).should eql(@setting)
    end
  end

  describe '.by_bundle' do

    before :each do
      @setting = Settings.all.first
      @invalid = Settings.all.last
      @setting.update_attributes(bundle: 'system')
      @invalid.update_attributes(bundle: 'invalid')
    end

    it "should return settings in the bundle" do
      Ryte::Setting::List.by_bundle(@setting.bundle).should include(@setting)
    end

    it "should not return a setting not in the bundle" do
      Ryte::Setting::List.by_bundle(@setting.bundle).should_not include(@invalid)
    end
  end

  describe '.by_type' do

    before :each do
      @setting = Settings.all.first
      @invalid = Settings.all.last
      @setting.update_attributes(type: 'system')
      @invalid.update_attributes(type: 'invalid')
    end

    it "should return a setting by name" do
      Ryte::Setting::List.by_type(@setting.type).should include(@setting)
    end

    it "should not return a setting not in the type" do
      Ryte::Setting::List.by_type(@setting.type).should_not include(@invalid)
    end
  end

  describe ".load" do

    before :each do
      Settings.all.delete_all
    end

    it "should save a list of settings" do
      expect {
        Settings.load([build(:ryte_setting)])
      }.to change(Settings.all, :count).by(1)
    end
  end

  describe ".save_and_reload" do

    before :each do
      @list = Settings.list
    end

    it "should call save on the settings list" do
      @list.should_receive(:save)
      Settings.save_and_reload
    end

    it "should receive 'list' with refresh true" do
      Settings.stub_chain(:list, :save).and_return(true)
      Settings.should_receive(:list).with(true)
      Settings.save_and_reload
    end
  end

  describe '.users_path' do

    it 'should be correct' do
      path = File.join(Rails.root, 'spec', 'support', 'user')
      Settings.users_path.should eql(path)
    end
  end

  describe ".current_theme" do

    it "should call 'by_name' on settings" do
      Settings.current_theme.should eql('default')
    end
  end

  describe "current_theme=" do

    before :each do
      Settings.current_theme.should eql('default')
    end

    it "should set the name of the current_theme" do
      Settings.current_theme = 'test'
      Settings.current_theme.should eql('test')
    end
  end
end
