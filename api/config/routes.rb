Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :subscriptions do
    member do
      post :sync
    end
  end
  resources :videos
  resources :jobs
  resources :settings, only: [:index] do
    collection do
      post :update
    end
  end
end
