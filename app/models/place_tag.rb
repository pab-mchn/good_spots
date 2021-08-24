class PlaceTag < ApplicationRecord
  belongs_to :place
  belongs_to :tag
  validates :place, uniqueness: { scope: :tag }
end
