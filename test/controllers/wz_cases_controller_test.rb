require 'test_helper'

class WzCasesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get wz_cases_index_url
    assert_response :success
  end

  test "should get create" do
    get wz_cases_create_url
    assert_response :success
  end

  test "should get show" do
    get wz_cases_show_url
    assert_response :success
  end

  test "should get edit" do
    get wz_cases_edit_url
    assert_response :success
  end

  test "should get update" do
    get wz_cases_update_url
    assert_response :success
  end

  test "should get destroy" do
    get wz_cases_destroy_url
    assert_response :success
  end

end
