module FaspBase
  class User < ApplicationRecord
    has_many :servers

    has_secure_password
  end
end
