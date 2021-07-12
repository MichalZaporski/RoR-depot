require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:three)
    @payment = payments(:one)
  end

  test "should create a payment" do
    post collect_payment_url,
         params: { id: 'pay_123123', description: "Order ID: #{@order.id}", state: 'executed' },
         headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(ESP_VAL[:login_basic_auth], ESP_VAL[:pass_basic_auth]) }

    assert_response :ok
  end

  test "should update a payment" do
    post collect_payment_url,
         params: { id: @payment.payment_id, description: "Order ID: #{@order.id}", state: 'executed' },
         headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(ESP_VAL[:login_basic_auth], ESP_VAL[:pass_basic_auth]) }

    assert_response :ok
  end

  test "shouldn't be authorized" do
    post collect_payment_url,
         params: { id: @payment.payment_id, description: "Order ID: #{@order.id}", state: 'executed' },
         headers: { Authorization: 'bad auth'}

    assert_response :unauthorized
  end

  test "shouldn't add payment, bad param" do
    post collect_payment_url,
         params: { id: 'pay_test3', description: "Order ID: #{@order.id}", bad_state: 'test' },
         headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(ESP_VAL[:login_basic_auth], ESP_VAL[:pass_basic_auth]) }

    assert_response :unprocessable_entity
  end

  test "shouldn't add payment, unknown order" do
    post collect_payment_url,
         params: { id: 'pay_test4', description: "Order ID: 0", state: 'executed' },
         headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(ESP_VAL[:login_basic_auth], ESP_VAL[:pass_basic_auth]) }

    assert_response :unprocessable_entity
  end

end
