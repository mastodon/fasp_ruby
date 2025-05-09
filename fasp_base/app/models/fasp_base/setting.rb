module FaspBase
  class Setting < ApplicationRecord
    OPTIONS = {
      registration: %w[open closed invite_only].freeze
    }.freeze

    def self.get(name)
      Rails.cache.fetch("fasp_base_setting_#{name}") do
        value = find_by(name:)&.value
        ActiveSupport::StringInquirer.new(value || "")
      end
    end

    validates :value,
      inclusion: {
        in: ->(attr) { OPTIONS[attr[:name].to_sym] },
        if: ->(attr) { OPTIONS[attr[:name].to_sym] }
      }

    after_commit :clear_cache

    private

    def clear_cache
      Rails.cache.delete("fasp_base_setting_#{name}")
    end
  end
end
