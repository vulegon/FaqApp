class PostsController < ApplicationController
  before_action :logged_in_user, only: :new
  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    else
      render "new"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = "更新が完了しました。"
      redirect_to @post
    else
      render "edit"
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to root_url
  end

  private
    #新規投稿時のtitleとcontentのみ許可する
    def post_params
      #マスアサインメント対策 :post属性の内容の属性のみ許可する
      params.require(:post).permit(:title,:content)
    end
    
end