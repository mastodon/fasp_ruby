module FaspBase::ServerExtensions
  extend ActiveSupport::Concern

  prepended do
    has_many :logs
  end
end
