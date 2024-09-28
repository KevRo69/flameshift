class Care < ApplicationRecord
  has_many :user_cares
  has_many :users, through: :user_cares
end
