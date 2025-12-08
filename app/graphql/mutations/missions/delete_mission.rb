# frozen_string_literal: true

module Mutations
  module Missions
    class DeleteMission < BaseMutation
      argument :id, ID, required: true

      field :success, Boolean, null: false
      field :errors, [ String ], null: false

      def resolve(id:)
        user = require_authenticated_user!

        mission = user.missions.find_by(id: id)
        return { success: false, errors: [ "Mission not found" ] } unless mission

        if mission.destroy
          { success: true, errors: [] }
        else
          { success: false, errors: mission.errors.full_messages }
        end
      end
    end
  end
end
