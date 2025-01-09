class UserManeuver < ApplicationRecord
  belongs_to :user
  validates :year, presence: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
