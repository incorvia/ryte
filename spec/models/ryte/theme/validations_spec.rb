require 'spec_helper'

describe Ryte::Theme::Validations do

  let(:theme) { Ryte::Theme.new('default') }

  describe "constants" do

    [:BUNDLE_KEYS].each do |constant|
      describe "#{constant}" do

        it "should exist" do
          Ryte::Theme.constants.should include(constant)
        end
      end
    end
  end
end
