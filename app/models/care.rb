class Care < ApplicationRecord
  has_many :user_cares, dependent: :destroy
  has_many :users, through: :user_cares
end
