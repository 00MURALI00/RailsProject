require "test_helper"

class AnswerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get answer_index_url
    assert_response :success
  end

  test "should get edit" do
    get answer_edit_url
    assert_response :success
  end

  test "should get show" do
    get answer_show_url
    assert_response :success
  end
end
