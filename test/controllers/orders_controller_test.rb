require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = customers(:one)
    sign_in @customer
  end

  test "should get index" do
    get orders_index_url
    assert_response :success
  end
end