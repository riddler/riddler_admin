Rails.application.routes.draw do
  root to: "users#index"
  resources :users do
    get "set_current", on: :member
  end
  mount RiddlerAdmin::Engine => "/riddler_admin"
end
