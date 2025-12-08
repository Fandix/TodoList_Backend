# frozen_string_literal: true

module Mutations
  module Missions
    class CreateMission < BaseMutation
      argument :input, Types::Mission::Inputs::CreateMissionInput, required: true

      field :mission, Types::Mission::MissionType, null: true
      field :errors, [ String ], null: false

      def resolve(input:)
        user = require_authenticated_user!
        mission = user.missions.build(input.to_h)

        if mission.save
          { mission: mission, errors: [] }
        else
          { mission: nil, errors: mission.errors.full_messages }
        end
      end
    end
  end
end
