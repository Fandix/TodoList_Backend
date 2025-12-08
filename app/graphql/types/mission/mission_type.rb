# frozen_string_literal: true

module Types::Mission
  class MissionType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :completed, Boolean, null: false
    field :due_date, GraphQL::Types::ISO8601DateTime
    field :priority, Integer, null: false
    field :category, String
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
