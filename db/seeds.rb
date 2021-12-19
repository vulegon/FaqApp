# メインのサンプルユーザーを1人作成する
User.create!(name:  "AdminUser",
  email: "admin@faqapp.org",
  password:              "password",
  password_confirmation: "password",
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

categories = [
  "HTML",
  "CSS",
  "JavaScript",
  "jquery",
  "Ruby",
  "Ruby on Rails",
  "PHP",
  "Java",
  "Python",
  "ターミナル",
  "Git",
  "SQL",
  "Sass",
  "Go"]
categories.each do |category|
  Category.create!(name: category)
end


users = User.order(:created_at).take(6)
50.times do |n|
  title = "sample_title#{n+1}"
  content = "sample_content#{n+1}"
  category_id = (n % categories.length) + 1
  users.each {|user| user.posts.create!(title: title, content: content, category_id: category_id)}
end
