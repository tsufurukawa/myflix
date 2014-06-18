class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user 
    redirect_to my_queue_path
  end

  private 

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless queued_video_already_exists?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def queued_video_already_exists?(video)
    current_user.queue_items.find_by(video: video)
  end
end