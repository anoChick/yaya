# frozen_string_literal: true

class User < ApplicationRecord
  has_many :codes
  has_many :webhooks
  has_many :characters

  validates :slack_id, presence: true, length: { maximum: 20 }
  validates :handle_name, presence: true
end
