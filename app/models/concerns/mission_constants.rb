# frozen_string_literal: true

module MissionConstants
  extend ActiveSupport::Concern

  # Category constants
  VALID_CATEGORIES = %w[work personal shopping health other].freeze

  # Priority level constants
  PRIORITY_LEVELS = {
    low: 0,
    medium: 1,
    high: 2,
    urgent: 3
  }.freeze

  MIN_PRIORITY = 0
  MAX_PRIORITY = 3

  # Length constraints
  MAX_TITLE_LENGTH = 100
  MAX_DESCRIPTION_LENGTH = 1000

  module ClassMethods
    def valid_categories
      VALID_CATEGORIES
    end

    def priority_levels
      PRIORITY_LEVELS
    end

    def priority_name(value)
      PRIORITY_LEVELS.key(value)&.to_s || "unknown"
    end
  end
end
