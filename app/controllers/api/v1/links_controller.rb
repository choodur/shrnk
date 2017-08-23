module Api
  module V1
    class LinksController < ActionController::API
      before_action :get_link

      def browsers
        @browsers = @link.get_visitor_stats_by(:browser)
      end

      def countries
        @countries = @link.get_visitor_stats_by(:country)
      end

      def os
        @operating_systems = @link.get_visitor_stats_by(:os)
      end

      private

      def get_link
        @link = Link.find_by!(short_url: params[:short_url])
      end
    end
  end
end

