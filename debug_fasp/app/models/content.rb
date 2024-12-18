class Content < ApplicationRecord
  has_many :trend_signals, dependent: :delete_all
end
