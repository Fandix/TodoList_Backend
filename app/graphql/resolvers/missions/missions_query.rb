# frozen_string_literal: true

module Resolvers
  module Missions
    class MissionsQuery < Resolvers::BaseResolver
      type Types::Mission::MissionConnectionType, null: false

      def self.connection?
        true
      end

      argument :completed, Boolean, required: false, description: "Filter by completion status"
      argument :category, String, required: false, description: "Filter by category"
      argument :sort_by, Types::Enums::MissionSortEnum, required: false, description: "Sort by field"
      argument :sort_order, Types::Enums::SortOrderEnum, required: false, description: "Sort order (asc/desc)"

      def resolve(completed: nil, category: nil, sort_by: nil, sort_order: nil)
        user = require_authenticated_user!

        scope = user.missions
        scope = scope.where(completed: completed) unless completed.nil?
        scope = scope.where(category: category) if category.present?

        sort_by ||= :created_at
        sort_order ||= :desc
        scope.order(sort_by => sort_order)
      end
    end
  end
end
