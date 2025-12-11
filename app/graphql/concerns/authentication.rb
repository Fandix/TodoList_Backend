# frozen_string_literal: true

module GraphqlConcerns
  module Authentication
    private

    def current_user
      context[:current_user]
    end

    def require_authenticated_user!
      current_user || raise(GraphQL::ExecutionError, "Not authenticated")
    end

    def require_authorization!(record)
      unless record.user_id == current_user&.id
        raise GraphQL::ExecutionError, "Not authorized"
      end
    end
  end
end
