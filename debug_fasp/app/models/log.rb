class Log < ApplicationRecord
  belongs_to :fasp_base_server, class_name: "FaspBase::Server"

  after_commit :perform_callback, on: :create

  private

  def perform_callback
    FaspBase::Request.new(fasp_base_server)
      .post("/debug/v0/callback/responses", body: request_body)
  end
end
