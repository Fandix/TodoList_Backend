# frozen_string_literal: true

module Mutations
  module Auth
    class SignUp < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :user, Types::UserType, null: true
      field :token, String, null: true
      field :errors, [ String ], null: false

      def resolve(email:, password:, password_confirmation:)
        user = User.new(
          email: email,
          password: password,
          password_confirmation: password_confirmation
        )

        if user.save
          token = generate_jwt_token(user)
          {
            user: user,
            token: token,
            errors: []
          }
        else
          {
            user: nil,
            token: nil,
            errors: user.errors.full_messages
          }
        end
      end

      private

      def generate_jwt_token(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
    end
  end
end
