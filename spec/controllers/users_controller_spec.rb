require 'rails_helper' 

describe UsersController do 
  describe "GET new" do 
    context "for authenticated users" do 
      before do 
        sets_current_user
        get :new
      end

      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end

      it "sets an error message" do 
        expect(flash[:danger]).not_to be_blank
      end
    end

    it "sets the @user variable for unauthenticated users" do   
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET new_with_invitation_token" do
    let(:invitation) { Fabricate(:invitation) }
    before { get :new_with_invitation_token, token: invitation.token }

    context "with valid token" do
      it "sets the @user variable with the recipient's email" do
        expect(assigns[:user].email).to eq(invitation.recipient_email)
      end

      it "sets the @invitation_token variable" do
        expect(assigns[:invitation_token]).to eq(invitation.token)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end

    context "with invalid token" do
      it "redirects to the expired token page" do
        get :new_with_invitation_token, token: "some token"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe "GET show" do 
    context "for authenticated users" do 
      before { sets_current_user }
      let(:user) { current_user }

      it "sets the @user variable" do 
        get :show, id: user.id
        expect(assigns(:user)).to eq(user) 
      end

      it "sets the @reviews variable" do 
        review1 = Fabricate(:review, user: user)
        get :show, id: user.id
        expect(assigns(:reviews)).to match_array([review1])
      end
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: 1 }
    end
  end

  describe "POST create" do 
    context "with valid input" do 
      after { ActionMailer::Base.deliveries.clear }
      
      it "creates a user" do
        post :create, user: { name: "Alice", email: "alice@example.com", password: "password" }
        expect(User.count).to eq(1)
      end

      it "sets the session for the user" do
        post :create, user: { name: "Alice", email: "alice@example.com", password: "password" }
        user = assigns(:user)
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home page" do
        post :create, user: { name: "Alice", email: "alice@example.com", password: "password" }
        expect(response).to redirect_to home_path
      end

      context "through invitation" do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: inviter) }
        before { post :create, user: { name: "Alice", email: "alice@example.com", password: "password" }, invitation_token: invitation.token }

        it "makes the user follow the inviter" do
          user = User.find_by_name("Alice")
          expect(user.already_following?(inviter)).to be_truthy
        end

        it "makes the inviter follow the user" do
          user = User.find_by_name("Alice")
          expect(inviter.already_following?(user)).to be_truthy
        end

        it "expires the invitation upon acceptance" do
          expect(Invitation.first.token).to be_nil
        end
      end

      context "email sending" do
        before { post :create, user: { name: "Alice", email: "alice@example.com", password: "password" } }

        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty    
        end

        it "sends to the right recipient" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq(["alice@example.com"])  
        end

        it "has the right content" do
          user = assigns(:user) 
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include("Welcome to Myflix, Alice")
        end
      end
    end

    context "with invalid input" do 
      before { post :create, user: { name: "Josh Smith" } }

      it "doesn't create any user" do 
        expect(User.count).to eq(0)
      end

      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "sets @user (but does not persist in database)" do 
        expect(assigns(:user)).to be_a_new(User)
      end

      it "does not send out the email" do 
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

