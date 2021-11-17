require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "ホームのページに関するリンクのテスト" do
    get root_url
    assert_response :success
  end
end
