class PaymentCallbacksController < ApplicationController
  skip_before_action :authorize

  def positive_response; end

  def negative_response; end
end
