class Ryte::Public::PostsController < Ryte::Public::BaseController

  def index
    @posts = Ryte::Post.all.to_a
    render_template(posts: @posts)
  end
end
