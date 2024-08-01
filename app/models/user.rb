class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: { admin: 0, user: 1 }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, presence: true, phony_plausible: true

  before_save :normalize_phone_number

  private

  def normalize_phone_number
    self.phone = PhonyRails.normalize_number(phone, default_country_code: 'BD')
  end
end
