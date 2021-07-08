Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  get 'admin/index'
  resources :users
  resources :products do
    get :who_bought, on: :member
  end

  controller :payment_callbacks do
    get 'payment_callbacks/negative_response'
    get 'payment_callbacks/positive_response'
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    get 'charge/index'
    root 'store#index', as: 'store_index', via: :all
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
