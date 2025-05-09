module FaspBase
  class InvitationCode < ApplicationRecord
    has_secure_token :code
  end
end
