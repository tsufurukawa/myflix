require 'rails_helper' 

describe SessionsController do 
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
    
    it "renders new template for unauthenticated users" do 
      get :new
      expect(response).to render_template :new
    end 
  end

  describe "POST create" do 
    let(:user) { Fabricate(:user) }

    context "with valid authentication" do 
      before { post :create, email: user.email, password: user.password }

      it "sets the session for the authenticated user" do
        expect(session[:user_id]).to eq(user.id)
      end 

      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end

      it "sets a success message" do 
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid authentication" do 
      let(:action) { post :create, email: user.email, password: "#{user.password} 123" }

      it "does not set the session for the user" do 
        action
        expect(session[:user_id]).to be_nil
      end

      it_behaves_like "require_sign_in" 
    end
  end

  describe "GET destroy" do 
    context "for authenticated users" do
      before do 
        sets_current_user
        get :destroy
      end

      it "clears the session for the user" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to front page" do 
        expect(response).to redirect_to root_path
      end

      it "sets an info message" do 
        expect(flash[:info]).not_to be_blank
      end
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { get :destroy }
    end
  end
end