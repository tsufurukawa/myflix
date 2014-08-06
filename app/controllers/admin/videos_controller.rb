class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "You've successfully added #{@video.title}!!"
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You are not authorized to do that."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :video_url, :category_id)
  end
end