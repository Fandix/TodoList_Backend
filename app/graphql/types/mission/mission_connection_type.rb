# frozen_string_literal: true

module Types::Mission
  class MissionConnectionType < Types::BaseConnection
    edge_type(Types::Mission::MissionEdgeType)
    field :total_count, Integer, null: false

    def total_count
      object.items.size
    end
  end
end
