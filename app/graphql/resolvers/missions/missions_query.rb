# frozen_string_literal: true

module Resolvers
  module Missions
    class MissionsQuery < Resolvers::BaseResolver
      type [ Types::Mission::MissionType ], null: false

      argument :completed, Boolean, required: false, description: "Filter by completion status"
      argument :category, String, required: false, description: "Filter by category"
      argument :search, String, required: false, description: "Search by title"
      argument :sort_by, Types::Enums::MissionSortEnum, required: false, description: "Sort by field"
      argument :sort_order, Types::Enums::SortOrderEnum, required: false, description: "Sort order (asc/desc)"
      argument :limit, Integer, required: false, description: "Maximum number of missions to return"
      argument :offset, Integer, required: false, description: "Number of missions to skip"

      DEFAULT_LIMIT = 50

      def resolve(completed: nil, category: nil, search: nil, sort_by: nil, sort_order: nil, limit: nil, offset: nil)
        user = require_authenticated_user!

        scope = user.missions
        scope = scope.where(completed: completed) unless completed.nil?
        scope = scope.where(category: category) if category.present?
        if search.present?
          pattern = "%#{search.downcase}%"
          scope = scope.where("LOWER(title) LIKE :pattern", pattern: pattern)
        end

        sort_by ||= :created_at
        sort_order ||= :desc
        limit = (limit || DEFAULT_LIMIT)
        offset = [ offset.to_i, 0 ].max

        scope.order(sort_by => sort_order).offset(offset).limit(limit)
      end
    end
  end
end
