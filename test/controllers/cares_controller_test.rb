require "test_helper"

class CaresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cares_index_url
    assert_response :success
  end

  test "should get show" do
    get cares_show_url
    assert_response :success
  end

  test "should get new" do
    get cares_new_url
    assert_response :success
  end

  test "should get create" do
    get cares_create_url
    assert_response :success
  end

  test "should get edit" do
    get cares_edit_url
    assert_response :success
  end

  test "should get update" do
    get cares_update_url
    assert_response :success
  end
end
