# frozen_string_literal: true

require_relative "../concerns/authentication"

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include GraphqlConcerns::Authentication
  end
end
