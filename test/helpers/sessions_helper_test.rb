require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "session[:user_id]が設定されていなくても永続定期なセッションが動いているかのテスト" do
    assert_equal @user,current_user
    assert is_logged_in?
  end

  test "remember_digestと記憶トークンが一致していない場合にcurrent_userがnilを返すかどうかのテスト" do
    @user.update_attribute(:remember_digest,User.digest(User.new_token))
    assert_nil current_user
  end

end
