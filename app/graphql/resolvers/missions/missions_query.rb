# frozen_string_literal: true

module Resolvers
  module Missions
    class MissionsQuery < Resolvers::BaseResolver
      type [ Types::Mission::MissionType ], null: false

      argument :input, Types::Mission::Inputs::MissionsQueryInput, required: false

      DEFAULT_LIMIT = 50
      MAX_LIMIT = 100

      def resolve(input: nil)
        user = require_authenticated_user!

        params = input&.to_h || {}
        sort_by = params[:sort_by] || :created_at
        sort_order = params[:sort_order] || :desc
        limit = [ [ (params[:limit] || DEFAULT_LIMIT).to_i, 1 ].max, MAX_LIMIT ].min
        offset = [ params[:offset].to_i, 0 ].max

        scope = user.missions
        scope = scope.where(completed: params[:completed]) unless params[:completed].nil?
        scope = scope.where(category: params[:category]) if params[:category].present?
        scope = scope.where(priority: params[:priority]) if params[:priority].present?
        if params[:search].present?
          pattern = "%#{params[:search].downcase}%"
          scope = scope.where("LOWER(title) LIKE :pattern", pattern: pattern)
        end

        scope.order(sort_by => sort_order).offset(offset).limit(limit)
      end
    end
  end
end
