require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "ユーザー一覧に関するテスト" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_difference "User.count",-1 do
      delete user_path(@non_admin)
    end
  end

  test "adminのユーザーでないなら削除を表示しないことを確認するテスト"do
    log_in_as(@non_admin)
    get users_path
    assert_select "a",text:"削除",count:0
  end
end
