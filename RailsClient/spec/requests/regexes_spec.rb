require 'rails_helper'

RSpec.describe "Regexes", :type => :request do
  describe "GET /regexes" do
    it "works! (now write some real specs)" do
      get regexes_path
      expect(response.status).to be(200)
    end
  end
end
