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
    Ryte::Post.create(post_params)
    redirect_to new_admin_post_path
  end

  private

  def post_params
    params.required(:post).permit(:body, :title)
  end
end
