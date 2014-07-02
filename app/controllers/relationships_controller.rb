class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @following_relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end

  def create
    followed_user = User.find(params[:followed_user_id])

    if current_user.can_follow?(followed_user)
      Relationship.create(follower: current_user, followed: followed_user)
      flash[:success] = "You are now following #{followed_user.name}." 
    end
    redirect_to people_path
  end
end