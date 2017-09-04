require 'test_helper'

class CottageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cottage_index_url
    assert_response :success
  end

end
