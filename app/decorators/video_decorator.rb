class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    reviews.present? ? "Rating: #{reviews.average(:rating).round(1)}/5.0" :"Not Yet Rated"
  end
end