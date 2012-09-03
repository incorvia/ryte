require 'spec_helper'

describe Ryte::Theme::Registration do
  
  let(:theme) { Ryte::Theme.new('default') }

  describe ".register!" do

    before :each do
      Ryte::Setting::List.create
      @theme = theme
      Ryte::Theme.stub!(:new).and_return(@theme)
    end

    context "settings are valid" do

      before :each do
        @theme.stub!(:valid?).and_return(true)
      end

      it "should call 'build!'" do
        @theme.should_receive(:build!)
        Ryte::Theme.register!('default')
      end

      context 'current is true' do

        it "should call 'set_current_theme!'" do
          Ryte::Theme.should_receive(:set_current_theme)
          Ryte::Theme.register!('default', true)
        end
      end
    end

    context "settings are invalid" do

      before :each do
        @theme.stub!(:valid?).and_return(false)
      end

      it "should not call 'build!'" do
        @theme.should_not_receive(:build!)
        Ryte::Theme.register!('default')
      end
    end
  end
end