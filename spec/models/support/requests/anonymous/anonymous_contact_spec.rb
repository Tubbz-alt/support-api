require 'rails_helper'
require 'support/requests/anonymous/anonymous_contact'

class TestContact < Support::Requests::Anonymous::AnonymousContact; end

module Support
  module Requests
    module Anonymous
      describe AnonymousContact, :type => :model do
        DEFAULTS = { javascript_enabled: true, url: "https://www.gov.uk/tax-disc", path: "/tax-disc" }

        def new_contact(options = {})
          TestContact.new(DEFAULTS.merge(options))
        end

        def contact(options = {})
          new_contact(options).tap { |c| c.save! }
        end

        it "enforces the presence of a reason why feedback isn't actionable" do
          contact = new_contact(is_actionable: false, reason_why_not_actionable: "")
          expect(contact).to_not be_valid
          expect(contact).to have_at_least(1).error_on(:reason_why_not_actionable)
        end

        it "doesn't detect personal info when none is present in free text fields" do
          expect(contact(details: "abc", what_wrong: "abc", what_doing: "abc").personal_information_status).to eq("absent")
        end

        it "notices when an email is present in one of the free text fields" do
          expect(contact(details: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
          expect(contact(what_doing: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
          expect(contact(what_wrong: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
        end

        it "notices when a national insurance number is present in one of the free text fields" do
          expect(contact(details: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
          expect(contact(what_doing: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
          expect(contact(what_wrong: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
        end

        it "validates the personal_information_status field" do
          expect(new_contact(personal_information_status: nil)).to be_valid
          expect(new_contact(personal_information_status: "suspected")).to be_valid
          expect(new_contact(personal_information_status: "absent")).to be_valid

          expect(new_contact(personal_information_status: "abcde")).to_not be_valid
        end

        it "stores the relative path of the page from which the feedback was lodged" do
          contact = new_contact(url: "https://www.gov.uk/vat-rates")
          contact.save!
          expect(contact.path).to eq("/vat-rates")
        end

        context "URLs" do
          it { should allow_value("https://www.gov.uk/something").for(:url) }
          it { should allow_value(nil).for(:url) }
          it { should allow_value("http://" + ("a" * 2040)).for(:url) }
          it { should_not allow_value("http://" + ("a" * 2050)).for(:url) }
          it { should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:url) }
        end

        context "path" do
          it { should allow_value("/something").for(:path) }
          it { should allow_value(nil).for(:path) }
          it { should allow_value("/" + ("a" * 2040)).for(:path) }
          it { should_not allow_value("/" + ("a" * 2050)).for(:path) }
          it { should_not allow_value("/méh/fào?bar").for(:path) }
        end

        context "referrer" do
          it { should allow_value("https://www.gov.uk/y").for(:referrer) }
          it { should allow_value(nil).for(:referrer) }
          it { should allow_value("http://" + ("a" * 2040)).for(:referrer) }
          it { should_not allow_value("http://" + ("a" * 2050)).for(:referrer) }
          it { should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:referrer) }
        end
      end
    end
  end
end
