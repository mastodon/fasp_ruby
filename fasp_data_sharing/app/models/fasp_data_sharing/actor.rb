module FaspDataSharing
  class Actor < ApplicationRecord
    def self.instance
      @instance ||= first || create!
    end

    before_create :create_keypair

    def public_key_pem
      private_key.public_to_pem
    end

    def private_key
      @private_key ||= OpenSSL::PKey.read(private_key_pem)
    end

    def username
      @username ||= FaspBase.fasp_name.parameterize.underscore
    end

    private

    def create_keypair
      self.private_key_pem = OpenSSL::PKey::RSA.new(2048).private_to_pem
    end
  end
end
