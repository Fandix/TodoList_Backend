# frozen_string_literal: true

module Mutations
  module Missions
    class UpdateMission < BaseMutation
      argument :input, Types::Mission::Inputs::UpdateMissionInput, required: true

      field :mission, Types::Mission::MissionType, null: true
      field :errors, [ String ], null: false

      def resolve(input:)
        user = require_authenticated_user!
        attributes = input.to_h
        id = attributes.delete(:id)

        mission = user.missions.find_by(id: id)
        return { mission: nil, errors: [ "Mission not found" ] } unless mission

        if mission.update(attributes)
          { mission: mission, errors: [] }
        else
          { mission: nil, errors: mission.errors.full_messages }
        end
      end
    end
  end
end
