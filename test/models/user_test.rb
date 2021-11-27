require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name:"Example_User", email:"user@examole.com",password: "foobar",password_confirmation: "foobar")
  end

  test "ユーザー名:ExampleUserでメールアドレスがuser@example.comの場合、有効かどうかのテスト" do
    assert @user.valid?
  end

  test "ユーザー名を空文字にした場合のテスト" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "メールアドレスを空文字にした場合のテスト" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "ユーザー名の長さに関するテスト" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  # 殆どのデータベースが文字列の上限を255としているため
  test "メールアドレスの長さに関するテスト" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "有効なメールアドレスの形式に関するテスト" do
    valid_addresses = %w[USER@foo.COM THE_US-ER@foo.bar.org first.last@foo.jp]
    #valid_addresses = ["USER@foo.COM", "THE_US-ER@foo.bar.org", "first.last@foo.jp"]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid? , "#{valid_address.inspect}は有効なメールアドレスの形式です"
    end
  end

  test "無効なメールアドレスの形式に関するテスト" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+bazcom]
    #invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.foo@bar_baz.com", "foo@bar+bazcom"]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? , "#{invalid_address.inspect}は無効なメールアドレスの形式です"
    end
  end

  test "メールアドレスがユニーク(一意)かどうかのテスト" do
    duplicate_user = @user.dup  #dupは同じ属性を持つデータを複製するメソッド
    duplicate_user.email = @user.email.upcase #upcaseでメールアドレスを大文字に変換
    @user.save
    assert_not duplicate_user.valid?
  end

  test "メールアドレスの大文字が小文字に変換されているかどうかのテスト" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "パスワードが空文字ではないことを検証するテスト" do
    @user.password = @user.password_confirmation = " " * 6
    # => @user.password = "" * 6, @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end

  test "パスワードの文字列が最低6文字以上であることを検証するテスト" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated?がnilだったらfalseを返すテスト" do
    assert_not @user.authenticated?(:remember,'')
  end
end
