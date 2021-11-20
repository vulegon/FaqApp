module SessionsHelper

  def log_in(user) #userにはuserオブジェクトが入る
    session[:user_id] = user.id
  end

  def current_user #全コントローラーで@current_user使えるようになる
    if session[:user_id] #データベースの問い合わせを減らすためにif文付ける
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil? #ログインしているならtrue、そうでないならfalse
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
