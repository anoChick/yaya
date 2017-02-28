class User < ActiveRecord::Base
  has_many :codes
  has_many :webhooks
  has_many :characters
  belongs_to :my_character, class_name: 'Character'
end
