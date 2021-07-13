class PaymentsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  http_basic_authenticate_with name: ESPAGO_VALUES[:login_basic_auth], password: ESPAGO_VALUES[:pass_basic_auth]

  skip_before_action :authorize
  skip_before_action :verify_authenticity_token

  before_action :set_subject_param

  def collect_payment
    if @subject == 'payment'
      set_payment_params
      set_order
      if (payment = Payment.find_by_payment_id @payment_params[1])
        payment.state = @payment_params[2]
      else
        payment = Payment.new(payment_id: @payment_params[1], state: @payment_params[2])
        payment.order = @order
      end
      payment.save!

      head :ok
    end
  rescue ActiveRecord::RecordInvalid
    # payment details didn't save
    head :unprocessable_entity
  end

  private

  def set_subject_param
    @subject = params.require :subject
  end

  def set_payment_params
    @payment_params = params.require %i[description id state subject]
  end

  def set_order
    @order = Order.find_by_id @payment_params[0].split.last.to_i
    @order&.assign_order_paytype('Credit card')
    @order&.save
  end

  def parameter_missing
    head :unprocessable_entity
  end
end
