require "test_helper"

class PostShowTest < ActionDispatch::IntegrationTest
  def setup
    @archer = users(:archer)
    @admin = users(:michael)
    @lana = users(:lana)
    @archer_post = posts(:html)
    @lana_post = posts(:python)
  end

  test "ログインしていない状態でpostの中身を見れることを確認するテスト" do
    get root_url
    assert_template "static_pages/home"
    get post_path(@archer_post)
    assert_template "posts/show"
    # 編集と削除は表示されていないことを確認する
    assert_select "a",text:"編集",count:0
    assert_select "a",text:"削除",count:0
  end

  test "自分の投稿であれば編集のリンクと削除のリンクが表示されていることを確認するテスト" do
    log_in_as(@archer)
    get root_url
    assert_template "static_pages/home"
    get post_path(@archer_post)
    assert_template "posts/show"
    # 編集と削除は表示されていないことを確認する
    assert_select "a",text:"編集",count:1
    assert_select "a",text:"削除",count:1
  end

  test "他者の投稿を覗いても編集のリンクしか表示されていないことを確認するテスト" do
    log_in_as(@archer)
    get root_url
    assert_template "static_pages/home"
    #別の人の投稿を見る
    get post_path(@lana_post)
    assert_template "posts/show"
    # 編集はできるが削除はないことを確認する
    assert_select "a",text:"編集",count:1
    assert_select "a",text:"削除",count:0
  end

  test "adminの場合は編集も削除もできることを確認するテスト" do
    log_in_as(@admin)
    get root_url
    assert_template "static_pages/home"
    #別の人の投稿を見る
    get post_path(@lana_post)
    assert_template "posts/show"
    # 編集はできるが削除はないことを確認する
    assert_select "a",text:"編集",count:1
    assert_select "a",text:"削除",count:1
  end
end
