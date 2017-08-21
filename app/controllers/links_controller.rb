class LinksController < ApplicationController
  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new
    @new_link = Link.shrink(link_params[:original_url])

    render :new
  end

  def redirect
    if @link = Link.find_by(short_url: params[:short_url])
      redirect_to @link.original_url, status: :moved_permanently
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  protected

  def link_params
    params.require(:link).permit(:original_url)
  end
end