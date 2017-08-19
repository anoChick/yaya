# frozen_string_literal: true

class Code < ApplicationRecord
  include Spell

  belongs_to :user
  belongs_to :character

  validates :name, presence: true
  validates :character, presence: true
  validates :user, presence: true

end
