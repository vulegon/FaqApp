class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index,:edit, :update]
  before_action :correct_user, only:[:edit, :update]

  def index
    @users = User.all
  end

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

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "更新が完了しました。"
      redirect_to @user
    else
      render "edit"
    end
  end

private

  def user_params
    #マスアサインメント対策 :user属性の名前、メールアドレス、パスワード、パスワードの確認属性のみ許可する
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location #sessions_helper アクセスしたURLを記憶する
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
