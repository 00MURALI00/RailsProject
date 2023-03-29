require "test_helper"

class QuestionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get question_index_url
    assert_response :success
  end

  test "should get showcreate" do
    get question_showcreate_url
    assert_response :success
  end

  test "should get new" do
    get question_new_url
    assert_response :success
  end

  test "should get edit" do
    get question_edit_url
    assert_response :success
  end

  test "should get update" do
    get question_update_url
    assert_response :success
  end

  test "should get destroy" do
    get question_destroy_url
    assert_response :success
  end
end
