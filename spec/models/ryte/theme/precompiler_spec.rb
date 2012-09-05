require 'spec_helper'

describe Ryte::Theme::Precompiler do

  describe '_env' do

    before :each do
      @_pre = Ryte::Theme::Precompiler
    end

    it 'should return the rails application assets array' do
      @_pre._env.should eql(Rails.application.assets)
    end

    it 'should return the rails application config assets paths array' do
      @_pre._paths.should eql(Rails.application.config.assets.paths)
    end
  end
end
