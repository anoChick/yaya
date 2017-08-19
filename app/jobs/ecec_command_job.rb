class ExecCommandJob < ActiveJob::Base
  queue_as :default

  def perform(params)
    params = JSON.parse(params)
    chara_name, command_name, *args = params['text'].split(' ')
    user = User.find_by(slack_id: params['user'])
    character = Character.find_by(name: chara_name)
    code = character.codes.find_by(name: command_name)
    workspace = Workspace.new(user, character,params['channel'])
    workspace.run(code.source_code, params)
  end
end
