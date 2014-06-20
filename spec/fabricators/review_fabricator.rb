Fabricator(:review) do 
  rating { rand(6) }
  content { Faker::Lorem.paragraph(2) }
end