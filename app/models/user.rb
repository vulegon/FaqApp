class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  #before_save { self.email = self.email.downcase }右式のselfは省略できる
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length:{maximum:50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length:{maximum:255},format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length:{minimum:6}, allow_nil: true

  #引数の文字列をハッシュ値にして返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムな文字列を返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #ランダムな文字列をハッシュ値にして永続セッションのためにデータベースに保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #ダイジェストとトークンが一致したらtrueを返す
  def authenticated?(attribute,token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #メールアドレスを小文字に変換
  def downcase_email
    self.email = email.downcase
  end

  #有効化のトークンとダイジェストトークンを作成
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def active
    update_columns(activated: true, activated_at: Time.zone.now)

  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

end
