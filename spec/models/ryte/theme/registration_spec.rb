require 'spec_helper'

describe Ryte::Theme::Registration do

  class Ryte::Theme
    include Ryte::Theme::Registration
  end

  describe '.register!' do

    it "should respond to 'register!'" do
      Ryte::Theme.should respond_to(:register!)
    end
  end
end
