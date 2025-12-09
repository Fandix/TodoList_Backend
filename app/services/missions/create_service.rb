# frozen_string_literal: true

module Missions
  class CreateService
    Result = Struct.new(:success?, :mission, :errors, keyword_init: true)

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      mission = @user.missions.build(@params)

      if mission.save
        Result.new(success?: true, mission: mission, errors: [])
      else
        Result.new(success?: false, mission: nil, errors: mission.errors.full_messages)
      end
    end
  end
end
