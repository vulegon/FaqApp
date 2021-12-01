require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "ログインしない状態で新規投稿に入ったらログインに促されるテスト" do
    get new_post_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  
end
