RiddlerAdmin::Engine.routes.draw do
  resources :steps do
    post "preview", on: :member
    get "preview", on: :member

    get "internal_preview", on: :member

    get "toggle", on: :member
  end

  resources :elements do
    put "sort", on: :collection
  end

  resources :preview_contexts

  resources :publish_requests do
    post "approve", on: :member
    post "publish", on: :member
  end
end
