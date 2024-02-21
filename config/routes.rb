require 'sidekiq/web'

Rails.application.routes.draw do
  draw :madmin
	authenticate :patron, lambda { |u| u.admin? } do
  	mount Sidekiq::Web => '/sidekiq'
	end

  devise_for :patrons, controllers: { omniauth_callbacks: "patrons/omniauth_callbacks" }
	get '/privacy', to: 'home#privacy'
	get '/terms', to: 'home#terms'
	root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
