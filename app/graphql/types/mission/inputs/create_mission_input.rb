# frozen_string_literal: true

module Types
  module Mission
    module Inputs
      class CreateMissionInput < Types::BaseInputObject
        argument :title, String, required: true
        argument :description, String, required: false
        argument :due_date, GraphQL::Types::ISO8601DateTime, required: false
        argument :priority, Integer, required: false
        argument :category, String, required: false
      end
    end
  end
end
