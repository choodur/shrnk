class LinksController < ApplicationController
  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.shrink(link_params[:original_url])
  end

  def redirect
    if @link = Link.find_by(short_url: params[:short_url])
      VisitRecorderJob.perform_async(@link.id, request.remote_ip, request.user_agent)
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