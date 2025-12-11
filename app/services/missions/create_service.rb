# frozen_string_literal: true

module Missions
  class CreateService < ApplicationService
    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      mission = @user.missions.build(@params)

      if mission.save
        success(mission)
      else
        failure(mission.errors.full_messages)
      end
    end
  end
end
