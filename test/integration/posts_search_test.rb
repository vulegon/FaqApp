require "test_helper"

class PostsSearchTest < ActionDispatch::IntegrationTest


  test "ログインしていない状態でも投稿の検索ができることを確認するテスト(カテゴリーなし)" do
    get root_path
    assert_template "static_pages/home"
    get search_path(search_content: "")
  end
end
