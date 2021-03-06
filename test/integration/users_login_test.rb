require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "ログイン失敗後にページを1回遷移してフラッシュが残っていないかを確認するテスト"do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {email:"",password:""}}
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "ユーザーのログアウトのテスト" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {email: @user.email, password: "password"}}
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_path #2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
  end

  test "メールアドレスは正しいがパスワードが間違っているテスト"do
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: {email: @user.email, password: "invalid"}}
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "remember_meがONでログインする場合のテスト" do
    log_in_as(@user,remember_me: "1")
    assert_not_empty cookies[:remember_token]
  end

  test "remember_meがOFFでログインする場合のテスト" do
    log_in_as(@user,remember_me: "1")
    delete logout_path
    log_in_as(@user,remember_me: "0")
    assert_empty cookies[:remember_token]
  end
  
end
