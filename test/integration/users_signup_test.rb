require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "無効なユーザー登録に関するテスト" do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "有効なユーザー登録に関するテスト" do
    get new_user_path
    assert_difference 'User.count',1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template "static_pages/home"
    assert is_logged_in? #test_helperのis_logged_in?を実行 ログインに成功しているはずなのでtrueになるはず
    assert_not flash.empty?
  end

end