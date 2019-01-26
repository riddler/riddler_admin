Rails.application.routes.draw do
  resources :users do
    get "set_current", on: :member
  end
  mount RiddlerAdmin::Engine => "/riddler_admin"
end
