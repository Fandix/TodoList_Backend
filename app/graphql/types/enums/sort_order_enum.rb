# frozen_string_literal: true

module Types::Enums
  class SortOrderEnum < Types::BaseEnum
    value "ASC", value: :asc
    value "DESC", value: :desc
  end
end
