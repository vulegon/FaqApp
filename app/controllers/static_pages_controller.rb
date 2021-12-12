class StaticPagesController < ApplicationController
  def home
    @posts = Post.all
    @value = ""
  end
end
