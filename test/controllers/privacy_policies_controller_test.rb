require 'test_helper'

class PrivacyPoliciesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get privacy_policies_show_url
    assert_response :success
  end

end
