class ChargeController < ApplicationController
  skip_before_action :authorize
  before_action :set_order
  before_action :set_payment_params
  before_action :set_swp_params, only: :index
  before_action :set_swp_items, only: :index

  def index; end

  def charge_client
    response = send_post_charge_req
    response_hash = JSON.parse response.as_json['body']
    security_url = check_redirect(response_hash)

    if security_url
      redirect_to security_url
    elsif response_hash['state'] == 'executed'
      redirect_to positive_response_url
    else
      redirect_to negative_response_url
    end
  end

  private

  def set_order
    @order = Order.find_by_id params[:order]
    redirect_to store_index_url unless @order
  end

  def set_payment_params
    @amount = '%.2f' % @order.total_price
    @currency = ESP_VAL[:currency]
    @description = "Name: #{@order.name} Address: #{@order.address}"
  end

  def set_swp_params
    @swp_api_version = ESP_VAL[:api_version]
    @swp_app_id = ESP_VAL[:app_id]
    @swp_kind = 'sale'
    @swp_session_id = SecureRandom.uuid
    @swp_currency = ESP_VAL[:currency]
    @swp_title = "Order ID: #{@order.id}"
    @swp_ts = Time.now.strftime '%s'
    @swp_checksum = ::Digest::MD5.hexdigest "#{@swp_app_id}|#{@swp_kind}|#{@swp_session_id}|#{@amount}|#{@currency}|#{@swp_ts}|#{ESP_VAL[:checksum_key]}"
  end

  def set_swp_items
    @swp_items = []
    @order.line_items.each do |line_item|
      quantity_ref = '%.2f' % line_item.quantity
      @swp_items << { description: line_item.product.title, quantity: quantity_ref, value: line_item.product.price }
    end
  end

  def send_post_charge_req
    auth_encoded = Base64.encode64("#{ESP_VAL[:app_id]}:#{ESP_VAL[:api_pass]}")

    Faraday.post('https://sandbox.espago.com/api/charges') do |req|
      req.headers['Authorization'] = "Basic #{auth_encoded}"
      req.headers['Accept'] = 'application/vnd.espago.v3+json'
      req.headers['Content-Type'] = 'application/json'
      req.body = { amount: @amount.to_f, currency: @currency, card: params[:card_token], description: @description }.to_json
    end
  end

  def check_redirect(hash)
    hash['redirect_url'] || hash['dcc_decision_information'] && hash['dcc_decision_information']['redirect_url']
  end
end
