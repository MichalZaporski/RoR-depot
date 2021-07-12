class PaymentsController < ApplicationController
  http_basic_authenticate_with name: ESP_VAL[:login_basic_auth], password: ESP_VAL[:pass_basic_auth]

  skip_before_action :authorize
  skip_before_action :verify_authenticity_token

  before_action :set_payment_params
  before_action :set_order

  def collect_payment
    if (payment = Payment.find_by_payment_id @paym_params[1])
      payment.state = @paym_params[2]
    else
      payment = Payment.new(payment_id: @paym_params[1], state: @paym_params[2])
      payment.order = @order
    end
    payment.save!

    head :ok
  rescue ActiveRecord::RecordInvalid
    # payment details didn't save
    head :unprocessable_entity
  end

  private

  def set_payment_params
    @paym_params = params.require %i[description id state]
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end

  def set_order
    @order = Order.find_by_id @paym_params[0].split.last.to_i
    @order&.assign_order_paytype('Credit card')
    @order&.save
  end
end
