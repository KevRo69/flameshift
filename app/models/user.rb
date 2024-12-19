class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_validation :capitalize_first_name
  before_validation :capitalize_last_name

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable
  belongs_to :team
  has_many :user_cares, dependent: :destroy
  has_many :cares, through: :user_cares
  has_many :availabilties, dependent: :destroy
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def capitalize_first_name
    self.first_name = first_name.capitalize if first_name.present?
  end

  def capitalize_last_name
    self.last_name = last_name.capitalize if last_name.present?
  end
end
