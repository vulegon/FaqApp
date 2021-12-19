class StaticPagesController < ApplicationController
  def home
    @posts = Post.all
    @categories = Category.all
    @search_category = nil
    @value = ""
  end
end
