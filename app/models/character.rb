# frozen_string_literal: true

class Character < ApplicationRecord
  belongs_to :user
  has_many :codes
  has_many :webhooks
  has_many :character_states
  validates :name, presence: true
  validates :user, presence: true
end
