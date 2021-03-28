class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy #koszyk ma wiele itemow, a po usunieciu koszyka itemy usuwaja sie
end
