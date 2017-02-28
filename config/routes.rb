Rails.application.routes.draw do
  resources :widgets

  root 'welcome#index'

  post 'webhooks/:uid' => 'webhooks#endpoint'
end
