shared_examples "require_sign_in" do 
  before do 
    clear_current_user
    action
  end

  it "redirects to sign-in page" do
    expect(response).to redirect_to sign_in_path
  end

  it "sets an error message" do 
    expect(flash[:danger]).not_to be_blank
  end
end

shared_examples "tokenable" do
  it "generates random token" do
    expect(obj.token).to be_present
  end
end

shared_examples "require_admin" do
  before do
    sets_current_user
    action
  end

  it "redirects to home path" do
    expect(response).to redirect_to home_path
  end

  it "sets a flash error message" do
    expect(flash[:danger]).to be_present
  end
end