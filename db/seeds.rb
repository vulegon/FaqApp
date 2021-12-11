# メインのサンプルユーザーを1人作成する
User.create!(name:  "MainUser",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = "sample#{n+1}"
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do |n|
  title = "sample_title#{n+1}"
  content = "sample_content#{n+1}"
  users.each {|user| user.posts.create!(title: title, content: content)}
end
  