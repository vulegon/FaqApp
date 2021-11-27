class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id]) #activated?>usersモデルのカラム
      user.active
      log_in user
      flash[:success] = "アカウント登録完了しました。"
      redirect_to root_url
    else
      flash[:danger] = "もう一度アカウントの登録をやり直してください。"
      redirect_to root_url
    end
  end
end
