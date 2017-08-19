# frozen_string_literal: true

class Webhook < ApplicationRecord
  include Spell

  belongs_to :user
  belongs_to :character

  validates :name, presence: true
  validates :uid, presence: true
  validates :channel, presence: true
  validates :character, presence: true
  validates :user, presence: true
  validates :url, presence: true

end
