require 'spec_helper'

describe Ryte::Theme::Matchers do

  let(:ryte_post) { create(:ryte_post) }

  describe 'Admin Path' do

    let(:template) { "{{ admin_path }}" }
    let(:response) { Braai::Template.new(template).render }

    it 'returns the path to the admin area' do
      response.should eql("/admins/sign_in")
    end
  end

  describe "Partials" do

    context 'no variables' do

      let(:template) { "{{ partial header }}" }
      let(:response) { Braai::Template.new(template).render }

      it "render the injected partial" do
        response.should match(/Header\ Partial/)
      end
    end

    context 'one partial variable' do

      let(:post) { create(:ryte_post, body: "body1") }
      let(:template) { "{{ partial header | foo: post }}" }
      let(:response) { Braai::Template.new(template).render(name: "Bobby", post: post) }

      it "renders the injected partial" do
        response.should match(/Header\ Partial/)
      end

      it "processes braai partial tags" do
        response.should match(/Bobby/)
      end

      it "passes variables as defined in tag" do
        response.should match(/body1/)
      end
    end

    context "multiply's partial variables" do

      let(:post) { create(:ryte_post, body: "body1") }
      let(:post2) { create(:ryte_post, body: "body2") }
      let(:template) { "{{ partial header | foo: post, foo2: post2 }}" }
      let(:response) do
        Braai::Template.new(template).render(name: "Bobby", post: post, post2: post2)
      end

      it "renders the injected partial" do
        response.should match(/Header\ Partial/)
      end

      it "processes braai partial tags" do
        response.should match(/Bobby/)
      end

      it "passes variables as defined in tag" do
        response.should match(/body1/)
      end

      it "passes variables as defined in tag" do
        response.should match(/body2/)
      end
    end
  end
end
