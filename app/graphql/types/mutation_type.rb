# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Auth mutations
    field :sign_up, mutation: Mutations::Auth::SignUp
    field :sign_in, mutation: Mutations::Auth::SignIn
    field :sign_out, mutation: Mutations::Auth::SignOut

    # Mission mutations
    field :create_mission, mutation: Mutations::Missions::CreateMission
    field :update_mission, mutation: Mutations::Missions::UpdateMission
    field :delete_mission, mutation: Mutations::Missions::DeleteMission
  end
end
