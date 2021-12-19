require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "ログインしていない状態でユーザー詳細画面に入ったときのテスト" do
    get  user_path(@user)
  end
end
