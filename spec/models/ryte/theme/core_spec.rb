require 'spec_helper'

describe Ryte::Theme::Core do

  let(:theme) { Ryte::Theme.new('default') }

  describe "initialize" do

    describe "required_files" do

      let(:r) { theme.required_files }

      it "should have theme specific required files" do
        r.should include('settings.yml')
        r.should include('views/index.html.erb')
        r.should include('stylesheets/styles.css')
      end
    end
  end
end
