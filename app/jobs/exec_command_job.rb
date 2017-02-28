class ExecCommandJob < ActiveJob::Base
  queue_as :default

  def perform(code_name, params)
    params = JSON.parse(params)
    chara_name, command, *args = params['text'].split(' ')
    user = User.find_by(slack_id: params['user'])
    character = Character.find_by(name: chara_name)
    code = character.codes.find_by(name: code_name)
    workspace = Workspace.new(user, character,context['channel'])
    workspace.run(code.source_code, params)
  end
end
