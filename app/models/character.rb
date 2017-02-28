class Character < ActiveRecord::Base
  belongs_to :user
  has_many :codes
  has_many :webhooks
  has_many :character_states
end
