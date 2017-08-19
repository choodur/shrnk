Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create]

  get '/:short_url' => 'links#show'

  root 'links#new'
end
