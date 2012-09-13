class Ryte::Admin::PostsController < Ryte::Admin::BaseController

  def index
  end

  def new
    @post = Ryte::Post.new
  end

  def create
    Ryte::Post.create(post_params)
    redirect_to new_admin_post_path
  end

  private

  def post_params
    params.required(:post).permit(:body)
  end
end