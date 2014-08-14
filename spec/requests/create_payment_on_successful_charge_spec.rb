require 'rails_helper'

describe "Creates payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_14RAEc4wLG6Oy3vFG35DbmM8",
      "created" => 1407968926,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14RAEb4wLG6Oy3vFj7OPtaOu",
          "object" => "charge",
          "created" => 1407968925,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14RAEb4wLG6Oy3vFtfJRAhso",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2014,
            "fingerprint" => "QgWwqM7FVfqMQcru",
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
            "customer" => "cus_4aKu5PRsEU6OUj"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14RAEb4wLG6Oy3vFj7OPtaOu/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_14RAEc4wLG6Oy3vFiDuUDc7l",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4aKu5PRsEU6OUj",
          "invoice" => "in_14RAEb4wLG6Oy3vFAGaTf41E",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4aKu1wZi7FHoXw"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded event", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4aKu5PRsEU6OUj")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates a payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4aKu5PRsEU6OUj")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates a payment with the reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4aKu5PRsEU6OUj")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_14RAEb4wLG6Oy3vFj7OPtaOu")
  end
end