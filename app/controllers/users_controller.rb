class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index,:edit, :update, :destroy]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy

  #GET  /users users_path
  def index
    @users = User.where(activated: true)
  end

  #GET  /users/:id user_path
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウントを有効化するメールを送信しました。メールをご確認ください。"
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end

private

  def user_params
    #マスアサインメント対策 :user属性の名前、メールアドレス、パスワード、パスワードの確認属性のみ許可する
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
