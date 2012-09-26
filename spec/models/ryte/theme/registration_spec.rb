require 'spec_helper'

describe Ryte::Theme::Registration do

  let(:theme) { Ryte::Theme.new('default') }

  describe ".register!" do

    before :each do
      Ryte::Setting::List.create
      setup_current_theme
      @theme = theme
      Ryte::Theme.stub!(:new).and_return(@theme)
    end

    context "settings are valid" do

      before :each do
        @theme.stub!(:valid?).and_return(true)
      end

      it "call 'build!'" do
        @theme.should_receive(:build!)
        Ryte::Theme.register!('default')
      end

      it "call 'add_to_registered_themes'" do
        @theme.should_receive(:add_to_registered_themes)
        Ryte::Theme.register!('default')
      end
    end

    context "settings are invalid" do

      before :each do
        @theme.stub!(:valid?).and_return(false)
      end

      it "not call 'build!'" do
        @theme.should_not_receive(:build!)
        Ryte::Theme.register!('default')
      end
    end
  end

  describe '.activate!' do

    it 'run the precompiler then set the theme' do
      Ryte::Theme::Precompiler.should_receive(:run!).ordered
      Settings.should_receive(:current_theme=).with('default').ordered
      Ryte::Theme.activate!('default')
    end
  end

  describe '.add_to_registered_themes' do

    before :each do
      setting = Settings.by_name('registered_themes')
      setting.value = []
      setting.save
    end

    it "add the theme to the registered_themes list" do
      theme.add_to_registered_themes
      Settings.by_name('registered_themes').value.should eql(['default'])
    end
  end
end
