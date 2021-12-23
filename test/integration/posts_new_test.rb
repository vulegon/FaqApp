require "test_helper"

class PostsNewTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @archer = users(:archer)
    @lana = users(:lana)
  end

  test "無効な投稿のテスト(タイトル空)" do
    log_in_as(@user)
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title:  "",
                                         content: "user@example.com",
                                         user_id: @user.id,
                                         category_id: 1 } }
    end
    assert_template 'posts/new'
  end

  test "無効な投稿のテスト(内容が空)" do
    log_in_as(@user)
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "",
                                         user_id: @user.id,
                                         category_id: 1 } }
    end
    assert_template 'posts/new'
  end

  test "無効な投稿のテスト(カテゴリーが未選択)" do
    log_in_as(@user)
    get new_post_path
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "",
                                         user_id: @user.id,
                                         category_id: nil } }
    end
    assert_template 'posts/new'
  end

  test "有効な投稿のテスト(admin)" do
    log_in_as(@user)
    get new_post_path
    assert_difference 'Post.count',1 do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "サンプル内容",
                                         user_id: @user.id,
                                         category_id: 1  } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    # 投稿されていることを確認する。
    assert_template 'static_pages/home'
    assert_select "a[href=?]",post_path(@user.posts.first)
    assert_select "a[href=?]",user_path(@user)
    get edit_post_path(@user.posts.first)
    # 投稿されているデータを編集して更新する
    assert_template "posts/edit"
    edit_title = "変更後タイトル"
    edit_content = "変更後内容"
    patch post_path(@user.posts.first),params: {post: {title: edit_title,content: edit_content,user_id:@user.id}}
    assert_not flash.empty?
    assert_redirected_to post_path(@user.posts.first)
    @user.posts.first.reload
    assert_equal edit_title, @user.posts.first.title
  end

  test "別の人が投稿したのを編集できることを確認するテスト" do
    log_in_as(@archer)
    get new_post_path
    assert_difference 'Post.count',1 do
      post posts_path, params: { post: { title:  "サンプルタイトル",
                                         content: "サンプル内容",
                                         user_id: @user.id,
                                         category_id: 1  } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]",post_path(@archer.posts.first)
    assert_select "a[href=?]",user_path(@archer)
    delete logout_path
    log_in_as(@lana)
    get edit_post_path(@archer.posts.first)
    assert_template "posts/edit"
    edit_title = "変更後タイトル"
    edit_content = "変更後内容"
    patch post_path(@archer.posts.first),params: {post: {title: edit_title,content: edit_content,user_id:@archer.id}}
    assert_not flash.empty?
    assert_redirected_to post_path(@archer.posts.first)
    @archer.posts.first.reload
    assert_equal edit_title, @archer.posts.first.title
  end

  
end
