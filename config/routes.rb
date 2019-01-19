RiddlerAdmin::Engine.routes.draw do
  resources :elements do
    put "sort", on: :collection
  end

  resources :preview_contexts

  resources :publish_requests do
    post "approve", on: :member
    post "publish", on: :member
  end

  resources :steps do
    get "internal_preview", on: :member
    post "preview", on: :member
    get "preview", on: :member
    get "toggle", on: :member
  end

  resources :slugs
end
