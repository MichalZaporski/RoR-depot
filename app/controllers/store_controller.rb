class StoreController < ApplicationController
  include CounterIndex, CurrentCart
  before_action :set_counter, only: %i[index]
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
