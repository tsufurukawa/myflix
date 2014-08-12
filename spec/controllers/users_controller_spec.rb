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
    context "successful user signup" do
      before do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets the session for the user" do
        expect(session[:user_id]).to eq(assigns(:user).id)
      end
    end

    context "failed signup with declined card" do
      before do
        result = double(:sign_up_result, successful?: false, declined_card?: true, error_message: "Your card was declined.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to eq("Your card was declined.")
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user (but does not persist in database)" do 
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context "failed signup with invalid personal info" do
      before do
        result = double(:sign_up_result, successful?: false, declined_card?: false)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { name: "Alice" }
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user (but does not persist in database)" do 
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end

