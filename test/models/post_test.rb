require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    category = categories(:HTML)
    @post = @user.posts.build(title:"サンプルタイトル", content:"サンプル本文",category_id:category.id)
  end

  test "有効なデータのテスト" do
    assert @post.valid?
  end

  test "ユーザーIDがnilのテスト" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "本文が空のデータのテスト" do
    @post.content = "  "
    assert_not @post.valid?
  end

  test "タイトルが空のデータのテスト" do
    @post.title = "  "
    assert_not @post.valid?
  end

  test "作成時間が最後のpostが最初に表示されるテスト" do
    assert_equal posts(:most_recent), Post.first
  end

  test "categoryがnilのテスト" do
    @post.category_id = nil
    assert_not @post.valid?
  end
end
