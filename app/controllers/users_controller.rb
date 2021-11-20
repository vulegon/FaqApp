class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #sessions_helperのlogin
      flash[:success] = "アカウントを登録しました。"
      #get redirect_to user_path(@user)
      #get redirect_to user_path(@user.id)
      #ex redirect_to user_path(1)→/users/1
      # redirect_to @user
      redirect_to root_url
    else
      render "new"
    end
  end

private

  def user_params
    #マスアサインメント対策 :user属性の名前、メールアドレス、パスワード、パスワードの確認属性のみ許可する
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
