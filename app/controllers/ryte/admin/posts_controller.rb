class Ryte::Admin::PostsController < Ryte::Admin::BaseController

  def index
    @posts = Ryte::Post.all
  end

  def new
    @post = Ryte::Post.new
  end

  def edit
    @post = Ryte::Post.find(params[:id])
  end

  def create
    post = Ryte::Post.create(post_params)
    redirect_by_status(post)
  end

  private

  def post_params
    params.require(:post).permit(:body, :title, :status)
  end

  def redirect_by_status(post)
    if post.published?
      redirect_to post_path(post)
    else
      redirect_to edit_admin_post_path(post)
    end
  end
end
