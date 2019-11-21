require 'test_helper'

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get inquiries_show_url
    assert_response :success
  end

end
