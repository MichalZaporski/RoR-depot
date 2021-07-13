class ChargeController < ApplicationController
  skip_before_action :authorize
  before_action :set_order
  before_action :set_payment_params
  before_action :set_swp_params, only: :index

  def index; end

  def charge_client
    response = ::Service::Payments::ChargeRequest.new(@payment_params).one_time_payment(params[:card_token])
    response_hash = JSON.parse response.as_json['body']
    security_url = check_redirect(response_hash)

    Payment.new(payment_id: response_hash['id'], order_id: @order.id).save

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
    @payment_params = ::Service::Payments::PaymentParams.new(@order)
  end

  def set_swp_params
    @payment_params.set_swp_params
    @payment_params.set_swp_items
  end

  def check_redirect(response_hash)
    response_hash['redirect_url'] || response_hash['dcc_decision_information'] && response_hash['dcc_decision_information']['redirect_url']
  end
end
