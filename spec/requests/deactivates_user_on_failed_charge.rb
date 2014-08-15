require 'rails_helper'

describe "Deactivates user on a failed charge" do
  let(:event_data) do
    {
      "id" => "evt_14RsJF4wLG6Oy3vFLbTELnPl",
      "created" => 1408138349,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14RsJF4wLG6Oy3vFjsE7nfIE",
          "object" => "charge",
          "created" => 1408138349,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14RsJ24wLG6Oy3vFvsErW85h",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2018,
            "fingerprint" => "YLDUT7d9Pg3W2837",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4aQj4lE3bzU4fs"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14RsJF4wLG6Oy3vFjsE7nfIE/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4aQj4lE3bzU4fs",
          "invoice" => nil,
          "description" => "Failed charge",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4b4ScH4RytgygW"
    }
  end

  after { ActionMailer::Base.deliveries.clear }

  it "deactivates a user with the webhook from stripe for charge failed event", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4aQj4lE3bzU4fs")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end

  it "sends out an email notifying the user of the deactivation", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4aQj4lE3bzU4fs")
    post "/stripe_events", event_data
    message = ActionMailer::Base.deliveries.last
    expect(ActionMailer::Base.deliveries).not_to be_empty
    expect(message.to).to eq([alice.email])
  end
end
