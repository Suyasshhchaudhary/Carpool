# Below are the routes for madmin
namespace :madmin do
resources :impersonates do
  post :impersonate, on: :member, as: :impersonate_patron
  post :stop_impersonating, on: :collection, as: :stop_impersonating_patron
end
  resources :patrons
  root to: "dashboard#show"
end
