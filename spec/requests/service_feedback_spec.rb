require 'rails_helper'
require 'support/requests/anonymous/service_feedback'

describe "Service feedback" do
  # In order to fix and improve my service (that's linked on GOV.UK)
  # As a service manager
  # I want to record and view bugs, gripes and improvement suggestions submitted by the service users

  before do
    the_date_is("2013-02-28")
  end

  it "accepts submissions with comments" do
    user_submits_satisfaction_survey_on_done_page(
      slug: "find-court-tribunal",
      path: "/done/find-court-tribunal",
      service_satisfaction_rating: 3,
      details: "Make service less 'meh'",
      user_agent: "Safari",
      javascript_enabled: true,
    )

    expect(Support::Requests::Anonymous::ServiceFeedback.where(slug: 'find-court-tribunal').count).to eq(1)
  end

  it "accepts submissions without comments" do
    user_submits_satisfaction_survey_on_done_page(
      slug: "apply-carers-allowance",
      path: "/done/apply-carers-allowance",
      service_satisfaction_rating: 3,
      details: nil,
      javascript_enabled: true,
    )

    expect(Support::Requests::Anonymous::ServiceFeedback.where(slug: 'apply-carers-allowance').count).to eq(1)
  end

  private
  def the_date_is(date_string)
    Timecop.travel Date.parse(date_string)
  end

  def user_submits_satisfaction_survey_on_done_page(options)
    post '/anonymous-feedback/service-feedback',
         { "service_feedback" => options }.to_json,
         {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

    expect(response.status).to eq(201)
  end
end
