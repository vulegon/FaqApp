require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:michael)
    @non_admin_user = users(:lana)
  end

  test "ログインしない状態で新規投稿に入ったらログインに促されるテスト" do
    get new_post_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "間違ったユーザーでログインしてpostを消そうとしたらホームページに戻されることを確認するテスト" do
    log_in_as(@non_admin_user)
    post = posts(:html)#archerのpost
    assert_no_difference "Post.count" do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end

  test "adminでログインしてpostを消そうとしたらホームページに戻されることを確認するテスト" do
    log_in_as(@admin_user)
    post = posts(:html)#archerのpost
    assert_difference "Post.count",-1 do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end

  test "自分のアカウントでログインして、自分の投稿postを消そうとしたらホームページに戻されることを確認するテスト" do
    log_in_as(@non_admin_user)
    post = posts(:python)#lanaのpost
    assert_difference "Post.count",-1 do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end
end
