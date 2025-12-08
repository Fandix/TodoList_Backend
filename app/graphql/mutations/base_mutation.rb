# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject

    private

    def current_user
      context[:current_user]
    end

    def require_authenticated_user!
      current_user || raise(GraphQL::ExecutionError, "Not authenticated")
    end
  end
end
