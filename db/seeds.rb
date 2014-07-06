# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Fabricate(:video, title: 'South Park', small_cover_url: 'south_park')
Fabricate(:video, title: 'Futurama', small_cover_url: 'futurama')
Fabricate(:video, title: 'South Park', small_cover_url: 'south_park')
Fabricate(:video, title: 'Monk', small_cover_url: 'monk')
Fabricate(:video, title: 'Futurama', small_cover_url: 'futurama')

Category.create(name: 'Drama')
Category.create(name: 'Comedy')
Category.create(name: 'Reality TV')

3.times do 
  Fabricate(:user, password: 'password')
end

Video.all.each do |video|
  User.all.each do |user|
    Fabricate(:review, rating: rand(6), user: user, video: video)
  end
end

Video.all.each do |video|
  video.category = Category.all.sample
  video.save
end