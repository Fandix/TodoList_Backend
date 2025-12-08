# frozen_string_literal: true

module Types::Mission
  class MissionEdgeType < Types::BaseEdge
    node_type(Types::Mission::MissionType)
  end
end
