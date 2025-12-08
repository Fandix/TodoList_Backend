# frozen_string_literal: true

module Mutations
  module Auth
    class SignOut < BaseMutation
      field :success, Boolean, null: false
      field :errors, [String], null: false

      def resolve
        user = context[:current_user]

        if user
          # Revoke JWT by updating jti
          user.update!(jti: SecureRandom.uuid)
          {
            success: true,
            errors: []
          }
        else
          {
            success: false,
            errors: ["Not authenticated"]
          }
        end
      end
    end
  end
end
