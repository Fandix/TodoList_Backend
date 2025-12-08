# frozen_string_literal: true

module Resolvers
  module Missions
    class MissionQuery < Resolvers::BaseResolver
      type Types::Mission::MissionType, null: true

      argument :id, ID, required: true

      def resolve(id:)
        user = require_authenticated_user!
        user.missions.find_by(id: id)
      end
    end
  end
end
