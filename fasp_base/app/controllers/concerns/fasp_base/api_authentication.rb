module FaspBase
  module ApiAuthentication
    extend ActiveSupport::Concern

    DIGEST_PATTERN = /sha-256=:(.*?):/
    KEYID_PATTERN = /keyid="(.*?)"/

    included do
      attr_reader :current_server
      helper_method :current_user

      skip_forgery_protection

      before_action :require_authentication

      after_action :sign_response
    end

    private

    def current_server
      @current_server
    end

    def current_user
      @current_user ||= current_server.user
    end

    def require_authentication
      validate_content_digest!
      validate_signature!
    rescue Error, ::Linzer::VerifyError, ActiveRecord::RecordNotFound => e
      logger.debug("Authentication error: #{e}")
      authentication_error
    end

    def authentication_error
      respond_to do |format|
        format.json { head :unauthorized }
      end
    end

    def validate_content_digest!
      content_digest_header = request.headers["content-digest"]
      raise Error, "content-digest missing" if content_digest_header.blank?

      digest_received = content_digest_header.match(DIGEST_PATTERN)[1]

      digest_computed = OpenSSL::Digest.base64digest("sha256", request.body&.string || "")

      raise Error, "content-digest does not match" if digest_received != digest_computed
    end

    def validate_signature!
      raise Error, "signature-input is missing" if request.headers["signature-input"].blank?

      server = nil

      ::Linzer.verify!(request.rack_request, no_older_than: 300) do |keyid|
        server = Server.find(keyid)
        ::Linzer.new_ed25519_public_key(server.public_key_pem, keyid)
      end

      @current_server = server
    end

    def sign_response
      response.headers["content-digest"] = "sha-256=:#{OpenSSL::Digest.base64digest("sha256", response.body || "")}:"

      key = ::Linzer.new_ed25519_key(current_server.fasp_private_key_pem)
      ::Linzer.sign!(response, key:, components: %w[@status content-digest])
    end
  end
end
