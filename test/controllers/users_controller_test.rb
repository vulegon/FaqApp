require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "ログインしていない状態でeditページにアクセスしたらログインページにredirectされるテスト" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "ログインしていない状態でupdateアクションを実行したらログインページにredirectされるテスト" do
    patch user_path(@user),params:{user:{name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "間違ったユーザーが編集しようとしたときのテスト(edit)" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "間違ったユーザーが編集しようとしたときのテスト(update)" do
    log_in_as(@other_user)
    patch user_path(@user),params:{user:{name: @user.name, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "ユーザー一覧を表示するテスト" do
    get users_path
    assert_redirected_to login_url
  end

  test "admin属性をユーザーのURL(/users/:id)に送って問題ないかを確認するテスト" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user),params:{user:{password: "password", password_confirmation: "password",admin: true}}
    assert_not @other_user.reload.admin?
  end

  test "ログインせずにdeleteのURLを実行したらログインを促すテスト"do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "管理者権限でログインしてdeleteのURLを実行したら削除が成功してhomeページにredirectされるテスト"do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url 
  end
end
