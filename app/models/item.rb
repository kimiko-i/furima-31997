class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :status
  belongs_to_active_hash :shipping
  belongs_to_active_hash :send_from
  belongs_to_active_hash :shipment_day

  has_one_attached :image
  belongs_to :user
  has_one :order

  with_options presence: true do
    validates :category_id, format: { with: /[2-9]|1[0-1]/, message: 'Select' }
    validates :status_id,        format: { with: /[2-7]/,  message: 'Select' }
    validates :shipping_id,      format: { with: /[2-3]/,  message: 'fee status Select' }
    validates :shipment_day_id,  format: { with: /[2-4]/,  message: 'Select' }
    validates :send_from_id,     format: { with: /[2-9]|[1-4][0-8]/, message: 'prefecture Select' }
    validates :name
    validates :price
    validates_inclusion_of :price, in: 300..9_999_999, message: 'Out of setting range'
    validates :detail
    validates :image, presence: { message: "can't be blank" }
  end
  validates :price, numericality: { with: /\A[0-9]+\z/, message: 'Half-width number' }
end
