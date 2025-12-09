# frozen_string_literal: true

module Missions
  class DeleteService
    Result = Struct.new(:success?, :errors, keyword_init: true)

    def initialize(user:, id:)
      @user = user
      @id = id
    end

    def call
      mission = @user.missions.find_by(id: @id)

      return Result.new(success?: false, errors: ["Mission not found"]) unless mission

      if mission.destroy
        Result.new(success?: true, errors: [])
      else
        Result.new(success?: false, errors: mission.errors.full_messages)
      end
    end
  end
end
