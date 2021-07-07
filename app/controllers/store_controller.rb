class StoreController < ApplicationController
  include CounterIndex, CurrentCart
  before_action :set_counter, only: %i[index]
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_lacale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
  end
end
