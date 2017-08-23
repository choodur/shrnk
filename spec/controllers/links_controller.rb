require 'rails_helper'

RSpec.describe LinksController, :type => :controller do
  describe 'GET #redirect' do
    let(:link) { Link.shrink('google.com') }

    context 'shortened URL exists' do
      it 'returns a 301 code' do
        get :redirect, params: { short_url: link.short_url }
        expect(response).to have_http_status(301)
      end

      it 'redirects to the original URL' do
        get :redirect, params: { short_url: link.short_url }
        expect(response['Location']).to eq(link.original_url)
      end
    end
  end
end