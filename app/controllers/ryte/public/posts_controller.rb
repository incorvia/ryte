class Ryte::Public::PostsController < Ryte::Public::BaseController

  def index
    @posts = Ryte::Post.where(status: "published").to_a
    render_template(posts: @posts)
  end

  def show
    @post = Ryte::Post.find(params[:id])
    render_template(post: @post)
  end
end
