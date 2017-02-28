class Webhook < ActiveRecord::Base
  belongs_to :user
  belongs_to :character

  def self.waiting_spell(name, user, character)
    where(user_id: user.id, waiting: true).update_all(waiting: false)

    find_or_create_by(name: name, user_id: user.id, character_id: character.id).update!(waiting: true)
  end

  def source_code
    agent = Mechanize.new
    agent.request_headers = { 'Authorization' => "Bearer #{ENV['SLACK_API_TOKEN']}" }
    page = agent.get(url)

    page.body.force_encoding('utf-8')
  end
end
