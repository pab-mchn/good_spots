class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :place_tags
  has_many :places, through: :place_tags
end
