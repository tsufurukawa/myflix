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
      before { post :create, user: Fabricate.attributes_for(:user) }
      
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
    end
  end
end

