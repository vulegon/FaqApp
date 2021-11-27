require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

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
    assert_equal 1,ActionMailer::Base.deliveries.size #送信されたメールが1通かの確認 deliversは変数なのでsetupで初期化する
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid_token",email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token,email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token,email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "static_pages/home"
    assert is_logged_in?
  end
end
