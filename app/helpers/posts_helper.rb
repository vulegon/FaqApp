module PostsHelper
  def post_img_remove(post_content)
    ApplicationController.helpers.strip_tags(post_content.to_s).gsub(/[n]/,"").strip.truncate(300)
  end
end
