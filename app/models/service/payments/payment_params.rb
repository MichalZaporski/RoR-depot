class ::Service::Payments::PaymentParams
  attr_reader :currency, :amount, :user_description, :title, :swp_api_version, :swp_app_id, :swp_kind, :swp_session_id, :swp_ts, :swp_checksum, :swp_items

  def initialize(order)
    @currency = ESPAGO_VALUES[:currency]
    @amount = '%.2f' % order.total_price
    @title = "Order ID: #{order.id}"
    @user_description = "Name: #{order.name} Address: #{order.address}"
    @order = order
  end

  def set_swp_params
    @swp_api_version = ESPAGO_VALUES[:api_version]
    @swp_app_id = ESPAGO_VALUES[:app_id]
    @swp_kind = 'sale'
    @swp_session_id = ::SecureRandom.uuid
    @swp_ts = ::Time.now.strftime '%s'
    @swp_checksum = ::Digest::MD5.hexdigest "#{@swp_app_id}|#{@swp_kind}|#{@swp_session_id}|#{@amount}|#{@currency}|#{@swp_ts}|#{ESPAGO_VALUES[:checksum_key]}"
  end

  def set_swp_items
    @swp_items = []
    @order.line_items.each do |line_item|
      quantity_ref = '%.2f' % line_item.quantity
      @swp_items << { description: line_item.product.title, quantity: quantity_ref, value: line_item.product.price }
    end
  end
end
