require "test_helper"

class PostShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:archer)
    @post = posts(:python)#lanaのpost
  end

  test"ログインしていない状態でpostの中身を見れることを確認するテスト"do
    get root_url
    assert_template "static_pages/home"
    get post_path(@post)
    assert_template "posts/show"
  end

  test"ログインしている状態でpostの中身を見れることを確認するテスト"do
    log_in_as(@user)
    get root_url
    assert_template "static_pages/home"
    get post_path(@post)
    assert_template "posts/show"
  end
end
