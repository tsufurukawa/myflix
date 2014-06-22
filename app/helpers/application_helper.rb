module ApplicationHelper
  def format_average_rating(rating)
    rating.nil? ? "Not Yet Rated" : "Rating: #{rating}/5.0"
  end 

  def options_for_review_ratings(selected=nil)
    options_for_select([5,4,3,2,1].map { |value| [pluralize(value, "Star"), value] }, selected)
  end
end

