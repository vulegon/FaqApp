class SessionsController < ApplicationController
  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています。"
      render "new"
    end

  end

  #DELETE /logout
  def destroy
    log_out
    redirect_to root_url
  end
end
