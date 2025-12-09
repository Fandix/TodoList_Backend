# frozen_string_literal: true

module Missions
  class UpdateService
    Result = Struct.new(:success?, :mission, :errors, keyword_init: true)

    def initialize(user:, id:, params:)
      @user = user
      @id = id
      @params = params
    end

    def call
      mission = @user.missions.find_by(id: @id)

      return Result.new(success?: false, mission: nil, errors: ["Mission not found"]) unless mission

      if mission.update(@params)
        Result.new(success?: true, mission: mission, errors: [])
      else
        Result.new(success?: false, mission: nil, errors: mission.errors.full_messages)
      end
    end
  end
end
