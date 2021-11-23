require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "ユーザー更新が失敗するテスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {user:{name:"", email:"foo@valid", password: "foo", password_confirmation: "bar"}}
    assert_template "users/edit"
  end

  test "ユーザー更新が成功するテスト" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "edit_success"
    email = "edit_success@example.com"
    patch user_path(@user), params: {user:{name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload #データベースから最新の情報を読み込みする
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
