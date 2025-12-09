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

        result = ::Missions::UpdateService.new(user: user, id: id, params: attributes).call

        { mission: result.mission, errors: result.errors }
      end
    end
  end
end
