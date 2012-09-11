class Ryte::Admin::PostsController < Ryte::Admin::BaseController

  def index
  end

  def new
    @post = Ryte::Post.new
  end
end
