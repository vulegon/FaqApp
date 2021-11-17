class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
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
