require 'rails_helper' 

describe SessionsController do 
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
    
    it "renders new template for unauthenticated users" do 
      get :new
      expect(response).to render_template :new
    end 
  end

  describe "POST create" do 
    context "with valid authentication" do 
      before do 
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password
      end

      it "sets the session for the authenticated user" do
        expect(session[:user_id]).to eq(@user.id)
      end 

      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end

      it "sets a success message" do 
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid authentication" do 
      before do 
        user = Fabricate(:user)
        post :create, email: user.email, password: "#{user.password} 123"
      end

      it "does not set the session for the user" do 
        expect(session[:user_id]).to be_nil
      end

      it "redirects to sign in page" do 
        expect(response).to redirect_to sign_in_path
      end

      it "sets an error message" do 
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do 
    context "for authenticated users" do
      before do 
        session[:user_id] = Fabricate(:user)
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

    context "for unauthenticated users" do 
      before { get :destroy }

      it "redirects to sign in page" do 
        expect(response).to redirect_to sign_in_path
      end

      it "sets an error message" do 
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end