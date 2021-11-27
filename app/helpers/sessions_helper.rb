module SessionsHelper

  #引数のユーザーオブジェクトでログインする
  def log_in(user) #userにはuserオブジェクトが入る
    session[:user_id] = user.id
  end

  #永続的なセッション
  def remember(user)
    user.remember #user.rbのremember remember_digestを設定する
    cookies.permanent.signed[:user_id] = user.id #.permanentでcookieの期限を20年 signedで暗号化
    cookies.permanent[:remember_token] = user.remember_token
  end

  #現在ログインしているユーザーを返す
  def current_user #全コントローラーで@current_user使えるようになる
    if (user_id = session[:user_id]) #データベースの問い合わせを減らすためにif文付ける
      @current_user ||= User.find_by(id: session[:user_id])
    elsif  (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  #ログインしているかどうかのチェック
  def logged_in?
    !current_user.nil? #ログインしているならtrue、そうでないならfalse
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #ログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  #渡されたユーザーがカレントユーザーならtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or
    redirect_to(session[:forwarding_url] || root_path)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get? #request.original_urlでリクエスト先を取得する
  end
end
