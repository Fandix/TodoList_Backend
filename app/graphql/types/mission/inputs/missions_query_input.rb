# frozen_string_literal: true

module Types
  module Mission
    module Inputs
      class MissionsQueryInput < Types::BaseInputObject
        description "Input for querying missions with filters, sorting and pagination"

        # Filters
        argument :completed, Boolean, required: false, description: "Filter by completion status"
        argument :category, String, required: false, description: "Filter by category"
        argument :search, String, required: false, description: "Search by title"

        # Sorting
        argument :sort_by, Types::Enums::MissionSortEnum, required: false, description: "Sort by field"
        argument :sort_order, Types::Enums::SortOrderEnum, required: false, description: "Sort order (asc/desc)"

        # Pagination
        argument :limit, Integer, required: false, description: "Maximum number of missions to return (max: 100)"
        argument :offset, Integer, required: false, description: "Number of missions to skip"
      end
    end
  end
end
