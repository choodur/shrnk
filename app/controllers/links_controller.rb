class LinksController < ApplicationController
  def show
    @link = if params[:short_url].present?
      Link.find_by(short_url: params[:short_url])
    elsif params[:id].present?
      Link.find(params[:id])
    end

    if @link
      redirect_to @link.original_url
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new
    @new_link = Link.shrink(link_params[:original_url])

    render :new
  end

  protected

  def link_params
    params.require(:link).permit(:original_url)
  end
end