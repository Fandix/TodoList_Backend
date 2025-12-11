# frozen_string_literal: true

module Mutations
  module Missions
    class CreateMission < BaseMutation
      argument :input, Types::Mission::Inputs::CreateMissionInput, required: true

      field :mission, Types::Mission::MissionType, null: true
      field :errors, [ String ], null: false

      def resolve(input:)
        user = require_authenticated_user!
        result = ::Missions::CreateService.new(user: user, params: input.to_h).call

        { mission: result.data, errors: result.errors }
      end
    end
  end
end
