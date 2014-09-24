require 'rails_helper'

module AnonymousFeedback
  describe ProblemReportsController do
    context "#totals" do
      it "returns a 404 for invalid dates" do
        get :totals, { date: "9999-99-99" }

        expect(response.status).to eq(404)
      end
    end
  end
end
