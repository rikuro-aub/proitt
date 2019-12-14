require 'test_helper'

class IntroductionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get introductions_show_url
    assert_response :success
  end

end
