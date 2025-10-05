class Setting < ApplicationRecord
  validates :last_day, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 29 }
  validates :days_waiting, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 , less_than: 6 }
  validates :rules, presence: true
end
