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
    @post = Post.find_by(id: params[:id])
  end

  private
    #新規投稿時のtitleとcontentのみ許可する
    def post_params
      #マスアサインメント対策 :post属性の内容の属性のみ許可する
      params.require(:post).permit(:title,:content)
    end
    
end
