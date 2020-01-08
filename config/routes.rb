Rails.application.routes.draw do
  resources :histories
  resources :orders, only: [:index, :edit, :create, :show, :destroy]
  resources :brands
  resources :products

  get '/brands/:id/close', to: 'brands#close', as: 'close_brand'
  get '/brands/:id/reopen', to: 'brands#reopen', as: 'reopen_brand'

  get '/orders/:id/new', to: 'orders#new', as: 'new_order'

  get '/other/clear', to: 'histories#clear', as: 'clear_history'
  root "orders#index"
end
