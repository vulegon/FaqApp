class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new,:create,:edit,:update,:destroy]
  before_action :correct_user, only: [:destroy]

  def new
    @post = Post.new
    @categories = Category.all
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
    get_search_params
    @categories = Category.all
    @posts = []
    if !@value.blank? && !@search_category.blank? 
      get_keywords(@value)
      search_posts(@keywords)
      category_id = Category.find_by(name: @search_category).id 
      @posts = @posts.select{|post| post[:category_id]==category_id}
    elsif !@search_category.blank?  && @value.blank? #side_barのcategoryがあったら
      category_id = Category.find_by(name: @search_category).id
      @posts = Post.where(category_id: category_id)
    elsif !@value.blank? && @search_category.blank? #search_formのvalueがあったら
      redirect_to root_path if  @value.blank?
      get_keywords(@value)
      search_posts(@keywords)
    else
      redirect_to root_path
    end      
  end

  private
    #新規投稿時のtitleとcontent,category_idのみ許可する
    def post_params
      #マスアサインメント対策 :post属性の内容の属性のみ許可する
      params.require(:post).permit(:title,:content,:category_id)
    end
    
    def correct_user
      @post = current_user.posts.find_by(id:params[:id])
      if !current_user.admin? && @post.nil?
        redirect_to root_url
      end
    end

    def get_search_params
      @value = params[:search_content]
      @search_category = params[:search_category]
    end

    def get_keywords(value)
      @keywords = value.split(/[[:blank:]]+/)
    end

    def search_posts(keywords)
      keywords.each do |keyword|
        #post.rb
        @posts += Post.search(keyword) unless keyword.blank?
      end
      @posts.uniq!
    end
end
