# frozen_string_literal: true

module Mutations
  module Auth
    class SignIn < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :token, String, null: true
      field :errors, [ String ], null: false

      def resolve(email:, password:)
        user = User.find_by(email: email)

        if user&.valid_password?(password)
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
            errors: [ "Invalid email or password" ]
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
