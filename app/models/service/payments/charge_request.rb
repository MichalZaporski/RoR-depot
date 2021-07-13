class ::Service::Payments::ChargeRequest
  def initialize(payment_params)
    @payment_params = payment_params
    @basic_auth_encoded = ActionController::HttpAuthentication::Basic.encode_credentials(ESPAGO_VALUES[:app_id],
                                                                                         ESPAGO_VALUES[:api_pass])
  end

  def one_time_payment(card_token)
    Faraday.post('https://sandbox.espago.com/api/charges') do |req|
      req.headers['Authorization'] = @basic_auth_encoded
      req.headers['Accept'] = 'application/vnd.espago.v3+json'
      req.headers['Content-Type'] = 'application/json'
      req.body = { amount: @payment_params.amount.to_f, currency: @payment_params.currency, card: card_token, description: @payment_params.title }.to_json
    end
  end
end
