class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  private

    def post_params
      #マスアサインメント対策 :post属性の内容の属性のみ許可する
      params.require(:post).permit(:title,:content)
    end
    
end
