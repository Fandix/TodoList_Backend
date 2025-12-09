# frozen_string_literal: true

module Mutations
  module Missions
    class DeleteMission < BaseMutation
      argument :id, ID, required: true

      field :success, Boolean, null: false
      field :errors, [ String ], null: false

      def resolve(id:)
        user = require_authenticated_user!
        result = ::Missions::DeleteService.new(user: user, id: id).call

        { success: result.success?, errors: result.errors }
      end
    end
  end
end
