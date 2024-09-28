class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  belongs_to :team
  has_many :user_cares
  has_many :cares, through: :user_cares
  has_many :availabilties, dependent: :destroy
  validates :first_name, :last_name, presence: true
end
