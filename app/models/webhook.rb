# frozen_string_literal: true

class Webhook < ApplicationRecord
  belongs_to :user
  belongs_to :character

  validates :name, presence: true
  validates :uid, presence: true
  validates :channel, presence: true
  validates :character, presence: true
  validates :user, presence: true
  validates :url, presence: true

  def self.waiting_spell(name, user, character)
    where(user_id: user.id, waiting: true).update_all(waiting: false)

    find_or_create_by(name: name, user_id: user.id, character_id: character.id).update!(waiting: true)
  end
end
