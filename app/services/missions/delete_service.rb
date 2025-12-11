# frozen_string_literal: true

module Missions
  class DeleteService < ApplicationService
    def initialize(user:, id:)
      @user = user
      @id = id
    end

    def call
      mission = @user.missions.find_by(id: @id)

      return failure("Mission not found") unless mission

      if mission.destroy
        success
      else
        failure(mission.errors.full_messages)
      end
    end
  end
end
