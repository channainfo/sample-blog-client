class CommentsController < ApplicationController
  before_action :load_post

  def new
    @comment = Resource::Comment.new(name: '', body: '')
  end

  def create
    @comment = Resource::Comment.new(filter_params)
    @comment.post = @post

    if @comment.valid? &&  @comment.save
      redirect_to post_path(params[:post_id]), notice: 'Comment created successfully'
    else
      flash.now[:error] = "Failed to create comment"
      render :new
    end
  end

  def filter_params
    params.require(:resource_comment).permit(:name, :body)
  end

  def load_post
    @post = Resource::Post.find(params[:post_id])
  end
end
