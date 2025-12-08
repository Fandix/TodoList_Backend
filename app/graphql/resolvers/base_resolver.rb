# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    private

    def current_user
      context[:current_user]
    end

    def require_authenticated_user!
      current_user || raise(GraphQL::ExecutionError, "Not authenticated")
    end
  end
end
