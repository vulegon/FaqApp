require "test_helper"

class PostsNewTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "無効な投稿のテスト(タイトル空)" do
    log_in_as(@user)
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title:  "",
                                         content: "user@example.com",
                                         user_id: @user.id } }
    end
    assert_template 'posts/new'
  end

  test "無効な投稿のテスト(内容が空)" do
    log_in_as(@user)
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "",
                                         user_id: @user.id } }
    end
    assert_template 'posts/new'
  end

  test "有効な投稿のテスト" do
    log_in_as(@user)
    get new_post_path
    assert_difference 'Post.count',1 do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "サンプル内容",
                                         user_id: @user.id  } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
  end

end
