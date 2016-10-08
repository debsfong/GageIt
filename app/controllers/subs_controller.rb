class SubsController < ApplicationController

  before_action :require_log_in, only: [:new, :create]
  before_action :require_moderator, only: [:edit, :update]

  def require_log_in
    if current_user.nil?
      flash[:errors] = ["Must be logged in"]
      redirect_to subs_url
    end
  end

  def require_moderator
    sub_gage = Sub.find(params[:id])
    unless current_user.id == sub_gage.moderator_id
      flash[:errors] = ["You are not the moderator of this sub"]
      redirect_to sub_url(Sub.find(params[:id]))
    end
  end

  def index
    @subs = Sub.all
    render :index
  end

  def new
  end

  def create
    @sub = Sub.new(sub_params)
    if @sub.valid?
      @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    if @sub
      render :show
    else
      flash[:errors] = ["No such sub"]
      redirect_to subs_url
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    if @sub
      render :edit
    else
      flash[:errors] = ["No such sub"]
      redirect_to subs_url
    end
  end

  def update
    @sub = Sub.find(params[:id])
    @sub.update(sub_params)
    redirect_to sub_url(@sub)
  end

  def destroy
    Sub.delete(params[:id].to_i)
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

end
