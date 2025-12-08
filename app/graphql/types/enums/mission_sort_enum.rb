# frozen_string_literal: true

module Types::Enums
  class MissionSortEnum < Types::BaseEnum
    value "CREATED_AT", value: :created_at
    value "UPDATED_AT", value: :updated_at
    value "DUE_DATE", value: :due_date
    value "PRIORITY", value: :priority
    value "TITLE", value: :title
  end
end
