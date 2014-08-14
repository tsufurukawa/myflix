require 'rails_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :index }
    end

    it "sets the @payments variable, returning payments in descending order by id" do
      sets_current_admin
      payment1 = Fabricate(:payment)
      payment2 = Fabricate(:payment)
      payment3 = Fabricate(:payment)
      get :index
      expect(assigns(:payments)).to eq([payment3, payment2, payment1])
    end

    it "sets the @payments variable, limiting the number of returned records to 10" do
      sets_current_admin
      12.times do
        Fabricate(:payment)
      end
      get :index
      expect(assigns(:payments).count).to eq(10)
    end
  end
end