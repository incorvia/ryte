require 'spec_helper'

describe Ryte::Theme::Precompiler do

  before :each do
    @_pfix = Ryte::Theme::Precompiler
  end

  describe '_env' do

    it 'should return the rails application assets array' do
      @_pfix._env.should eql(Rails.application.assets)
    end
  end

  describe '_paths' do

    it 'should return the rails application config assets paths array' do
      @_pfix._paths.should eql(Rails.application.config.assets.paths)
    end
  end

  describe 'run!' do

    it 'should receive load_paths and precompile ordered' do
      @_pfix.should_receive(:load_paths).ordered
      @_pfix.should_receive(:precompile).ordered
      @_pfix.run!
    end
  end

  describe 'load_paths' do

    it 'should receive clear_paths and append_paths ordered' do
      @_pfix._env.should_receive(:clear_paths).ordered
      @_pfix.should_receive(:append_paths).ordered
      @_pfix.run!
    end
  end

  describe 'append_paths' do

    let(:paths) { @_pfix._paths + Settings.assets_dirs }

    it 'should append default and new asset paths' do
      paths.each do |path|
        @_pfix._env.should_receive(:append_path).with(path)
      end
      @_pfix.append_paths
    end
  end
end
