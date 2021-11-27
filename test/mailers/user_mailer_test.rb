require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "アカウント有効化のテスト" do
    user = users(:michael)
    user.activation_token = User.new_token #トークンを生成
    mail = UserMailer.account_activation(user) #app/mailers/user_mailer.rb
    assert_equal "アカウントの有効化", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@faqapp.com"], mail.from
    assert_match user.name, mail.text_part.body.encoded
    assert_match user.name, mail.html_part.body.encoded #名前がメール本文に使われているか
    assert_match user.activation_token, mail.text_part.body.encoded
    assert_match user.activation_token, mail.html_part.body.encoded
    assert_match CGI.escape(user.email), mail.text_part.body.encoded
    assert_match CGI.escape(user.email), mail.html_part.body.encoded #CGIでメールアドレスをエスケープ処理 amazonのURLでみる%とかのやつ
  end

end
