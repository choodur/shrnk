Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create] do
    collection do
      get 'redirect/:short_url' => :redirect
    end
  end

  get '/:short_url' => 'links#redirect'

  root 'links#new'
end
