class ExecCommandJob < BaseJob
  queue_as :default

  def perform(code_name, params)

  end
end
