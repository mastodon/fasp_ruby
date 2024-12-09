class Fasp::Debug::V0::Callback::LogsController < Fasp::ApiController
  def create
    Log.create(
      fasp_base_server: current_server,
      ip: request.remote_ip,
      request_body: request.raw_post
    )

    head :created
  end
end
