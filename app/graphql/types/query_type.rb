# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true, description: "Returns the currently authenticated user"
    def me
      context[:current_user]
    end

    field :missions, resolver: Resolvers::Missions::MissionsQuery
    field :mission, resolver: Resolvers::Missions::MissionQuery
  end
end
