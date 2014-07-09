require 'rails_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets the @invitation variable for authenticated users" do
      sets_current_user
      get :new
      expect(assigns[:invitation]).to be_a_new(Invitation)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    context "with valid input" do
      let(:user) { Fabricate(:user) }
      before { sets_current_user(user) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates an invitation with the signed-in user as the inviter" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(Invitation.first.inviter).to eq(user)
      end

      it "sends out an email to the recipient" do
        post :create, invitation: { recipient_name: "Tom", recipient_email: "tom@example.com", message: "Hey Tom" }
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["tom@example.com"])
      end

      it "redirects to the invite page" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(response).to redirect_to invite_path
      end

      it "sets a flash success message" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      let(:user) { Fabricate(:user) }

      before do 
        sets_current_user(user)
        post :create, invitation: { recipient_name: "Tom" }
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "doesn't create any invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "sets the @invitation variable" do
        expect(assigns[:invitation]).to be_a_new(Invitation)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
    end
  end
end