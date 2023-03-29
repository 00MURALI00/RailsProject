require "test_helper"

class OptionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get option_index_url
    assert_response :success
  end

  test "should get show" do
    get option_show_url
    assert_response :success
  end

  test "should get create" do
    get option_create_url
    assert_response :success
  end

  test "should get edit" do
    get option_edit_url
    assert_response :success
  end

  test "should get update" do
    get option_update_url
    assert_response :success
  end
end
