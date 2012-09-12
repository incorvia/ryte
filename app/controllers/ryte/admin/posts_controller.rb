class Ryte::Admin::PostsController < Ryte::Admin::BaseController

  def index
  end

  def new
    @post = Ryte::Post.new
  end

  def create
    Ryte::Post.create(post_params)
  end

  private

  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def post_params
    params.required(:post).permit(:body)
  end
end
