class Place < ApplicationRecord
  belongs_to :category
  has_many :viewings
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :latitude, presence: true, uniqueness: true
  validates :longitude, presence: true, uniqueness: true
  validates :description, presence: true
  validates :telephone_number, presence: true, uniqueness: true
  validates :website_url, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
