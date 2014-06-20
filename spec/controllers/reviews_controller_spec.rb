require 'rails_helper' 

describe ReviewsController do 
  describe "POST create" do 
    let(:video) { Fabricate(:video) }

    context "for authenticated users" do 
      let(:authenticated_user) { Fabricate(:user) }
      before { session[:user_id] = authenticated_user.id }

      context "with valid input" do 
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
        
        it "redirects to the show video page" do 
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with a video" do 
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed-in user" do
          expect(Review.first.user).to eq(authenticated_user)
        end

        it "sets a success message" do 
          expect(flash[:success]).not_to be_blank
        end
      end

      context "with invalid input" do 
        it "doesn't create a review" do
          post :create, review: { rating: 3 }, video_id: video.id 
          expect(Review.count).to eq(0)
        end

        it "renders videos/show template" do 
          post :create, review: { rating: 3 }, video_id: video.id 
          expect(response).to render_template "videos/show"
        end
      
        it "sets @reviews" do 
          review1 = Fabricate(:review, video: video)
          review2 = Fabricate(:review, video: video)
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review1, review2])
        end

        it "sets @review" do 
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:review)).to be_a_new(Review)
        end

        it "sets @video" do 
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end
      end 
    end

    context "for unauthenticated users" do 
      before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
      
      it "sets an error message" do 
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end