# frozen_string_literal: true

module Types
  module Mission
    module Inputs
      class UpdateMissionInput < Types::BaseInputObject
        argument :id, ID, required: true
        argument :title, String, required: false
        argument :description, String, required: false
        argument :completed, Boolean, required: false
        argument :due_date, GraphQL::Types::ISO8601DateTime, required: false
        argument :priority, Integer, required: false
        argument :category, String, required: false
      end
    end
  end
end
