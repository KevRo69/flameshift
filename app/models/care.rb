class Care < ApplicationRecord
  has_many :user_cares, dependent: :destroy
  has_many :users, through: :user_cares

  accepts_nested_attributes_for :user_cares, allow_destroy: true
end
