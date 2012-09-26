require 'spec_helper'

describe Ryte::Theme::Precompiler do

  before :each do
    @_pfix = Ryte::Theme::Precompiler
  end

  describe '_env' do

    it 'returns the rails application assets array' do
      @_pfix._env.should eql(Rails.application.assets)
    end
  end

  describe '_paths' do

    it 'returns the rails application config assets paths array' do
      @_pfix._paths.should eql(Rails.application.config.assets.paths)
    end
  end

  describe 'run!' do

    context 'compress is true' do

      before :each do
        Ryte::Application.stub_chain(:config, :assets, :compress).and_return(true)
      end

      it 'receives load_paths and precompile ordered' do
        @_pfix.should_receive(:load_paths).ordered
        @_pfix.should_receive(:precompile).ordered
        @_pfix.run!
      end
    end

    context 'compress is false' do

      before :each do
        Ryte::Application.stub_chain(:config, :assets, :compress).and_return(false)
      end

      it 'receives load_paths and precompile ordered' do
        @_pfix.should_receive(:load_paths).ordered
        @_pfix.should_not_receive(:precompile).ordered
        @_pfix.run!
      end
    end

  end

  describe 'load_paths' do

    it 'receives clear_paths and append_paths ordered' do
      @_pfix._env.should_receive(:clear_paths).ordered
      @_pfix.should_receive(:append_paths).ordered
      @_pfix.run!
    end
  end

  describe 'append_paths' do

    let(:paths) { @_pfix._paths + Settings.assets_dirs }

    it 'append default and new asset paths' do
      paths.each do |path|
        @_pfix._env.should_receive(:append_path).with(path)
      end
      @_pfix.append_paths
    end
  end
end
