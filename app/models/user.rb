class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :items
  has_many :purchases

  with_options presence: true do
    validates :first_name,       format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'Full-width characters' }
    validates :last_name,        format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'Full-width characters' }
    validates :first_name_kana,  format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'Full-width katakana characters' }
    validates :last_name_kana,   format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'Full-width katakana characters' }
    validates :nickname
    validates :birthday
  end

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'include both letters and numbers'
end
