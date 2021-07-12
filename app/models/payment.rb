class Payment < ApplicationRecord
  belongs_to :order
  validates_uniqueness_of :payment_id
end
