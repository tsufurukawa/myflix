module ApplicationHelper
  def options_for_review_ratings(selected=nil)
    options_for_select([5,4,3,2,1].map { |value| [pluralize(value, "Star"), value] }, selected)
  end
end