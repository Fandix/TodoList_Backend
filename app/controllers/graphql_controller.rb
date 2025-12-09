# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user
    }
    result = TodoListSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def current_user
    auth_header = request.headers["Authorization"]
    return nil unless auth_header.present?

    token = extract_bearer_token(auth_header)
    return nil unless token

    decode_jwt_token(token)
  end

  def extract_bearer_token(auth_header)
    parts = auth_header.split(" ")
    return nil unless parts.length == 2
    return nil unless parts[0].casecmp("bearer").zero?
    return nil if parts[1].length > 500

    parts[1]
  end

  def decode_jwt_token(token)
    Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
  rescue JWT::DecodeError => e
    Rails.logger.warn("JWT::DecodeError: #{e.message}")
    nil
  rescue JWT::ExpiredSignature
    Rails.logger.warn("JWT token expired")
    nil
  rescue Warden::JWTAuth::Errors::RevokedToken
    Rails.logger.warn("JWT token revoked")
    nil
  rescue StandardError => e
    Rails.logger.error("Unexpected JWT error: #{e.class} - #{e.message}")
    nil
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end
