# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "json"
require "httparty"

Viewing.delete_all
PlaceTag.delete_all
Tag.delete_all
Place.delete_all


response = HTTParty.get('https://dev.ofdb.io/v0/search?bbox=42.27,-7.97,52.58,38.25&limit=2000')
response = JSON.parse(response.body)
places = response["visible"]
berlin_places = places.select do |place|
  lat_condition = place["lat"] > 52.00 && place["lat"] < 52.99
  lng_condition = place["lng"] > 13.00 && place["lng"] < 13.99
  lat_condition && lng_condition
end

berlin_places.each do |place|
  place_tags = place["tags"]
  new_place = Place.create!(
    name: place["title"],
    lat: place["lat"],
    lng: place["lng"],
    description: place["description"],
    recommended: [true, false].sample
  )
  puts "Place: '#{new_place.name}' has been created"
  puts "Assigning tags"
  place_tags.each do |tag|
    tag = tag.gsub("-", " ")
    tag = tag.capitalize
    tag = Tag.find_or_create_by(name: tag)
    PlaceTag.create!(place: new_place, tag: tag)
    puts "Tag: '#{tag.name}' has been created and assigned to '#{new_place.name}'"
  end
end

puts ""
puts ""
puts ""
puts ""
puts ""

puts "Congrats, you now have #{Place.count} places and #{Tag.count} tags"
# validates :name, presence: true, uniqueness: true
# # Acordate de poner un random value en recommended
# validates :lat, presence: true, uniqueness: true
# validates :lng, presence: true, uniqueness: true
# validates :description, presence: true
