require 'rails_helper' 

describe UsersController do 
  describe "GET new" do 
    context "for authenticated users" do 
      before do 
        session[:user_id] = Fabricate(:user).id
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

  describe "POST create" do 
    context "with valid input" do 
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a user" do 
        expect(User.count).to eq(1)
      end

      it "sets the session for the user" do 
        user = assigns(:user)
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid input" do 
      before do 
        post :create, user: { name: "Josh Smith" }
      end

      it "doesn't create any user" do 
        expect(User.count).to eq(0)
      end

      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "sets @user (but does not persist)" do 
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end

