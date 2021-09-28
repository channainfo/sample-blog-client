class PostsController < ApplicationController
  def new
    @post = Resource::Post.new(title: '', body: '')
  end

  def create
    @post = Resource::Post.new(filter_params)
    if @post.valid? &&  @post.save
      redirect_to posts_path, notice: 'Post created successfully'
    else
      flash.now[:error] = "Failed to create post"
      render :new
    end
  end

  def show
    @post = Resource::Post.find(params[:id])
    @comments = @post.comments
  end

  def index
    @posts = Resource::Post.all
  end

  def filter_params
    params.require(:resource_post).permit(:title, :body)
  end
end
