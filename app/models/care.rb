class Care < ApplicationRecord
  has_many :user_cares, dependent: :destroy
  has_many :users, -> { order('user_cares.created_at ASC') }, through: :user_cares

  accepts_nested_attributes_for :user_cares, allow_destroy: true
end
