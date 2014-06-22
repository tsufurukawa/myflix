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
    current_user.normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position number"
    end
    redirect_to my_queue_path
  end

  private 

  def queue_video(video)
    unless current_user.queued_video_already_exists?(video)
      QueueItem.create(video: video, user: current_user, position: current_user.new_queue_item_position) 
    end
  end

  def update_queue_items
    ActiveRecord::Base.transaction do 
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position], rating: queue_item_data[:rating]) if queue_item.user == current_user
      end
    end
  end
end