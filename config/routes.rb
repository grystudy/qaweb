Rails.application.routes.draw do

  resources :wz_cases do
    collection do
      get 'begin'
      get 'confirm'
      get 'delete_all'
    end
  end
  root 'wz_cases#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
