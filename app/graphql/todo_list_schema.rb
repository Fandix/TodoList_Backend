# frozen_string_literal: true

class TodoListSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  use GraphQL::Dataloader

  # Query safety limits
  max_query_string_tokens(5000)
  validate_max_errors(100)
  max_complexity(200)
  max_depth(10)

  # Error handling
  rescue_from(ActiveRecord::RecordNotFound) do |_err, _obj, _args, _ctx, _field|
    raise GraphQL::ExecutionError, "Record not found"
  end

  rescue_from(ActiveRecord::RecordInvalid) do |err, _obj, _args, _ctx, _field|
    raise GraphQL::ExecutionError, err.record.errors.full_messages.join(", ")
  end
end
