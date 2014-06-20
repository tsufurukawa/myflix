module ApplicationHelper
  def format_average_rating(rating)
    rating.nil? ? "Not Yet Rated" : "Rating: #{rating}/5.0"
  end 
end

