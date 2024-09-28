class UserCare < ApplicationRecord
  belongs_to :user
  belongs_to :care
end
