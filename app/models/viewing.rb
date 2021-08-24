class Viewing < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates :liked, presence: true
end
