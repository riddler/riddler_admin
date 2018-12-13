RiddlerAdmin::Engine.routes.draw do
  resources :steps
  resources :elements do
    put "sort", on: :collection
  end
end
