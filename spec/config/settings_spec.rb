require 'spec_helper'

describe "Settings" do

  let(:required) do
    %w(current_theme)
  end

  before :each do
    Ryte::Setting::List.create
    file = File.open(Ryte::Config.settings_path)
    @loader = Ryte::Setting::YamlLoader.new(file)
    @loader.build_and_commit
  end

  it "should create 'current_theme' with correct values" do
    setting = Settings.by_name('current_theme')
    setting.name.should eql('current_theme')
    setting.value.should eql('default')
    setting.display.should eql('Current Theme')
  end
end
