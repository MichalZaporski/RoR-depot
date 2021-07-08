class ChargeController < ApplicationController
  skip_before_action :authorize
  before_action :set_order
  before_action :set_swp_params
  before_action :set_swp_items

  def index; end

  private

  def set_order
    @order = Order.find_by_id params[:order]
    redirect_to 'store_index' unless @order
  end

  def set_swp_params
    @swp_api_version = ESP_VAL[:api_version]
    @swp_app_id = ESP_VAL[:app_id]
    @swp_kind = 'sale'
    @swp_session_id = SecureRandom.uuid
    @swp_amount = '%.2f' % @order.total_price
    @swp_currency = ESP_VAL[:currency]
    @swp_title = "Order ID: #{@order.id}"
    @swp_description = "Name: #{@order.name} Address: #{@order.address}"
    @swp_ts = Time.now.strftime '%s'
    @swp_checksum = ::Digest::MD5.hexdigest "#{@swp_app_id}|#{@swp_kind}|#{@swp_session_id}|#{@swp_amount}|#{@swp_currency}|#{@swp_ts}|#{ESP_VAL[:checksum_key]}"
  end

  def set_swp_items
    @swp_items = []
    @order.line_items.each do |line_item|
      quantity_ref = '%.2f' % line_item.quantity
      @swp_items << { description: line_item.product.title, quantity: quantity_ref, value: line_item.product.price }
    end
  end
end
