require 'rails_helper'

describe ApplicationHelper do 
  describe 'format_average_rating' do 
    it "returns the string 'Rating: rating/5.0' if a numerical rating is passed in" do 
      expect(format_average_rating(3.0)).to eq("Rating: 3.0/5.0")  
    end

    it "returns the string 'Not Yet Rated' if nil is passed in" do 
      expect(format_average_rating(nil)).to eq("Not Yet Rated")
    end
  end 
end