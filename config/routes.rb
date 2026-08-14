Rails.application.routes.draw do
  get "orders/index"
  devise_for :customers
  get "checkout/new"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: [ :index, :show ]

  get "cart", to: "cart#show", as: :cart

  post "cart/add/:id",
       to: "cart#add",
       as: :add_to_cart

  patch "cart/update/:id",
        to: "cart#update",
        as: :update_cart

  delete "cart/remove/:id",
         to: "cart#remove",
         as: :remove_from_cart

  # Checkout
  get "checkout", to: "checkout#new", as: :checkout
  post "checkout", to: "checkout#create"
  get "orders/:id", to: "checkout#show", as: :order
  get "my_orders", to: "orders#index", as: :my_orders
  post "checkout/create_session", to: "checkout#create_session", as: :checkout_create_session
  get "checkout/success", to: "checkout#success", as: :checkout_success
end
