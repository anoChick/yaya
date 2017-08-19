# frozen_string_literal: true

Rails.application.routes.draw do
  post 'webhooks/:uid' => 'webhooks#endpoint'
end
