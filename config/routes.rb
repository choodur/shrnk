Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create] do
    collection do
      get 'redirect/:short_url' => :redirect
    end
  end

  namespace :api do
    namespace :v1 do
      resources :links, param: :short_url, only: [:show] do
        member do
          get :browsers
          get :clicks
          get :countries
          get :os
        end
      end
    end
  end

  get '/:short_url' => 'links#redirect'

  root 'links#new'
end
