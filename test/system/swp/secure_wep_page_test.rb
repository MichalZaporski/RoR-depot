require "application_system_test_case"

class SecureWebPageTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    Capybara.default_max_wait_time = 15
  end

  test "secure web page - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4242 4242 4242'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'Payment successful'
  end

  test "secure web page - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4242 4242 4242'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'Payment failure'
  end

  test "secure web page eDCC - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4211 1111 2239'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'Payment successful'
  end

  test "secure web page eDCC - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4242 4211 1111 2239'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    click_on 'Powrót do sklepu'

    assert_text 'Payment failure'
  end

  test "secure web page 3D Secure - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 0000 0002 0006'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'
    within_frame do
      find(:css, "#confirm-btn", visible: :all).click
    end

    click_on 'Powrót do sklepu'

    assert_text 'Payment successful'
  end

  test "secure web page 3D Secure - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 0000 0002 0006'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'
    within_frame do
      find(:css, "#reject-btn", visible: :all).click
    end

    click_on 'Powrót do sklepu'

    assert_text 'Payment failure'
  end

  test "secure web page 3D Secure and eDCC - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 8888 8888 1881'
    select '01', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    fill_in 'code', with: '1234'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment successful'
  end

  test "secure web page 3D Secure and eDCC - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'Security Web Page'

    fill_in 'transaction_credit_card_attributes_first_name', with: 'name'
    fill_in 'transaction_credit_card_attributes_last_name', with: 'lastname'
    fill_in 'transaction_credit_card_attributes_number', with: '4012 8888 8888 1881'
    select '12', from: 'transaction_credit_card_attributes_month'
    select '28', from: 'transaction_credit_card_attributes_year'
    fill_in 'transaction_credit_card_attributes_verification_value', with: '123'
    click_on 'submit_payment'

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    fill_in 'code', with: '0000'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment failure'
  end
end