require 'rails_helper'

RSpec.describe "Testresults", type: :request do
  describe "GET /testresults" do
    it "works! (now write some real specs)" do
      get testresults_path
      expect(response).to have_http_status(200)
    end
  end
end
