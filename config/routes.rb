Rails.application.routes.draw do
  resources :widgets

  root 'welcome#index'

  get 'webhooks/:uid' => 'webhooks#endpoint'
end
