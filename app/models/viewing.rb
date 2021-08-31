class Viewing < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates :liked, inclusion: [true, false]
end