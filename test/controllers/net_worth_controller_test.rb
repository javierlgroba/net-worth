require "test_helper"

class NetWorthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get net_worth_index_url
    assert_response :success
  end
end
