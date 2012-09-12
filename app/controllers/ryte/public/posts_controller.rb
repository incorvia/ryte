class Ryte::Public::PostsController < Ryte::Public::BaseController

  before_filter :set_template

  def index
    @posts = Ryte::Post.all.to_a
    render text: Braai::Template.new(@template).render(posts: @posts)
  end

  private

  def set_template
    @template = Settings.current_template(params[:action]).read
  end
end
