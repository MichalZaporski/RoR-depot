require "application_system_test_case"

class IframeTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    Capybara.default_max_wait_time = 25
  end

  test "iFrame - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4242 4242 4242 4242'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    assert_text 'Payment successful'
  end

  test "iFrame - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4242 4242 4242 4242'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    assert_text 'Payment failure'
  end

  test "iFrame eDCC - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4242 4211 1111 2239'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    assert_text 'Payment successful'
  end

  test "iFrame eDCC - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4242 4211 1111 2239'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    assert_text 'Payment failure'
  end

  test "iFrame 3D Secure - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4012001037141112'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    fill_in 'code', with: '1234'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment successful'
  end

  test "iFrame 3D Secure - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4012001037141112'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    fill_in 'code', with: '0000'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment failure'
  end

  test "iFrame 3D Secure and eDCC - positive response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4012 8888 8888 1881'
      fill_in 'espago_month', with: '01'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    fill_in 'code', with: '1234'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment successful'
  end

  test "iFrame 3D Secure and eDCC - negative response" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    click_on 'Place Order'

    click_on 'iFrame'

    within_frame do
      fill_in 'espago_first_name', with: 'name'
      fill_in 'espago_last_name', with: 'lastname'
      fill_in 'espago_card_number', with: '4012 8888 8888 1881'
      fill_in 'espago_month', with: '12'
      fill_in 'espago_year', with: '2028'
      fill_in 'espago_verification_value', with: '123'
      click_on 'espago_form_submit'
    end

    find(:css, "#dcc_yes").set(true)
    click_on 'submit_payment'

    fill_in 'code', with: '0000'
    click_on 'Prześlij | Send', match: :first

    assert_text 'Payment failure'
  end
end