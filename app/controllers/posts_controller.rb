class PostsController < ApplicationController

  before_action :require_log_in, only: [:new, :create]
  before_action :require_author, only: [:edit, :update]

  def require_log_in
    if current_user.nil?
      flash[:errors] = ["Must be logged in"]
      redirect_to sub_url(Sub.find(params[:sub_id]))
    end
  end

  def require_author
    post = Post.find(params[:id])
    unless current_user.id == post.author_id
      flash[:errors] = ["You are not the author of this post"]
      redirect_to sub_post_url(post.sub_id, post)
    end
  end

  def new
    render :new
  end

  def create
    @post = Post.new(post_params)
    if @post.valid?
      @post.save
      redirect_to sub_post_url(@post.sub_id, @post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    if @post
      render :show
    else
      flash[:errors] = ["No such post"]
      parent_sub = Sub.find(params[:sub_id])
      redirect_to sub_url(parent_sub)
    end
  end

  def edit
    @post = Post.find(params[:id])
    if @post
      render :edit
    else
      flash[:errors] = ["No such post"]
      redirect_to sub_posts_url
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to sub_post_url(@post.sub_id, @post)
  end

  def destroy
    sub_id = params[:sub_id].dup
    Post.delete(params[:id].to_i)
    redirect_to sub_url(sub_id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
  end
end
