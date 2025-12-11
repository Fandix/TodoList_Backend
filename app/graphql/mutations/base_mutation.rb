# frozen_string_literal: true

require_relative "../concerns/authentication"

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    include GraphqlConcerns::Authentication

    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject
  end
end
