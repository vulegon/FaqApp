class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new,:create,:edit,:update,:destroy]
  before_action :correct_user, only: [:destroy]

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

  def search
    @value = params[:search_content]
    redirect_to root_path if  @value.blank?
    keywords = @value.split(/[[:blank:]]+/)
    @posts = []
    keywords.each do |keyword|
      #post.rb
      @posts += Post.search(keyword) unless keyword.blank?
    end
    @posts.uniq!

  end

  private
    #新規投稿時のtitleとcontentのみ許可する
    def post_params
      #マスアサインメント対策 :post属性の内容の属性のみ許可する
      params.require(:post).permit(:title,:content)
    end
    
    def correct_user
      @post = current_user.posts.find_by(id:params[:id])
      if !current_user.admin? && @post.nil?
        redirect_to root_url
      end
    end
end
