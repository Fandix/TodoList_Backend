# frozen_string_literal: true

module Missions
  class UpdateService < ApplicationService
    def initialize(user:, id:, params:)
      @user = user
      @id = id
      @params = params
    end

    def call
      mission = @user.missions.find_by(id: @id)

      return failure("Mission not found") unless mission

      if mission.update(@params)
        success(mission)
      else
        failure(mission.errors.full_messages)
      end
    end
  end
end
