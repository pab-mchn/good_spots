class Place < ApplicationRecord
  has_many :viewings
  has_many :place_tags
  has_many :tags, through: :place_tags
  # validates :name, presence: true, uniqueness: true
  # validates :address, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :description, presence: true
  # validates :telephone_number, presence: true, uniqueness: true
  # validates :website_url, presence: true, uniqueness: true
  # validates :email, presence: true, uniqueness: true
  reverse_geocoded_by :lat, :lng
  after_validation :reverse_geocode
end
