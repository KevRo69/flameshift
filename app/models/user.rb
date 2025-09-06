class User < ApplicationRecord
  acts_as_paranoid
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
  has_many :user_maneuvers, dependent: :destroy
  validates :first_name, :last_name, presence: true
  validates :password, presence: true, confirmation: true, length: { within: 6..128 }, on: :create
  validates :password, confirmation: true, length: { within: 6..128 }, allow_blank: true, on: :update
  accepts_nested_attributes_for :user_maneuvers, allow_destroy: true

  def active_for_authentication?
    super && !deactivated?
  end

  def inactive_message
    deactivated? ? :deactivated : super
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def maneuvers_count(year)
    user_maneuvers.where(year: year).first.nil? ? 0 : user_maneuvers.where(year: year).first.number
  end


  private

  def capitalize_first_name
    self.first_name = first_name.capitalize if first_name.present?
  end

  def capitalize_last_name
    self.last_name = last_name.capitalize if last_name.present?
  end
end
