require 'spec_helper'

describe Ryte::Theme do

  let(:theme) { Ryte::Theme.new }

  describe "validations" do

    describe "name_with_regex" do

      context 'valid' do

        before :each do
          theme.name = "foobar"
        end

        it "should return true" do
          theme.send(:name_with_regex).should be_true
        end
      end

      context 'invalid' do

        before :each do
          theme.name = 'foo bar'
        end

        it "should return false" do
          theme.send(:name_with_regex).should be_false
        end

        it "should add an error to the model" do
          expect {
            theme.send(:name_with_regex)
          }.to change(theme.errors, :count).by(1)
        end
      end
    end

    describe "files_with_required" do

      context "all files included" do

        before :each do
          @theme = theme
          Dir.stub!(:glob).and_return(Ryte::Theme::REQUIRED)
          @theme.stub!(:name).and_return("foo")
        end

        it "should return true" do
          @theme.send(:files_with_required).should be_true
        end
      end
    end
  end
end
