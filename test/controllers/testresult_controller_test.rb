require "test_helper"

class TestresultControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get testresult_index_url
    assert_response :success
  end

  test "should get show" do
    get testresult_show_url
    assert_response :success
  end
end
