RiddlerAdmin::Engine.routes.draw do
  resources :steps do
    post "preview", on: :member
    get "preview", on: :member
    get "toggle", on: :member
  end

  resources :elements do
    put "sort", on: :collection
  end

  resources :preview_contexts
end
