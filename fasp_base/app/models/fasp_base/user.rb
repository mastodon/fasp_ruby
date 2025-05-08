module FaspBase
  class User < ApplicationRecord
    has_many :servers

    has_secure_password

    def activate!
      update!(active: true)
    end

    def deactivate!
      update!(active: false)
    end
  end
end
