module FaspBase
  class UriValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add(attribute, :invalid) unless uri_valid?(value)
    end

    private

    def uri_valid?(string)
      uri = URI.parse(string)

      return false unless scheme_valid?(uri)
      return false unless host_valid?(uri.host)

      true
    rescue URI::Error
      false
    end

    def scheme_valid?(uri)
      return false unless uri.is_a?(URI::HTTP)
      return false unless options[:allow_http] || uri.is_a?(URI::HTTPS)

      true
    end

    def host_valid?(host)
      return false unless host.present?

      addresses = resolve_addresses(host)
      return false if addresses.empty?

      non_private?(addresses)
    end

    def resolve_addresses(host)
      Socket.getaddrinfo(host, nil)
        .map { |info| info[3] }
        .uniq
    rescue Socket::ResolutionError
      []
    end

    def non_private?(addresses)
      addresses.none? do |address|
        ipaddr = IPAddr.new(address)

        ipaddr.loopback? || ipaddr.link_local? || ipaddr.private?
      end
    end
  end
end
