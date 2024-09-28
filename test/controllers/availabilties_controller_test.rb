require "test_helper"

class AvailabiltiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get availabilties_index_url
    assert_response :success
  end

  test "should get nex" do
    get availabilties_nex_url
    assert_response :success
  end

  test "should get destroy" do
    get availabilties_destroy_url
    assert_response :success
  end
end
