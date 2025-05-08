module FaspBase
  class AdminUser < ApplicationRecord
    has_secure_password
  end
end
