# frozen_string_literal: true

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  def self.graphql_operation_name(req)
    return nil unless req.path == "/graphql" && req.post?

    body = req.body.read
    req.body.rewind

    parsed = JSON.parse(body)
    query = parsed["query"] || ""
    mutation_match = query.match(/mutation\s+(\w+)/) || query.match(/\{\s*(\w+)\s*\(/)
    mutation_match&.captures&.first
  rescue JSON::ParserError, StandardError
    nil
  end

  throttle("req/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path == "/graphql"
  end

  # Login: 5 times / 5 minutes limit
  throttle("logins/ip", limit: 5, period: 5.minutes) do |req|
    req.ip if graphql_operation_name(req) == "signIn"
  end

  # Signup: 3 times / 1 hour limit
  throttle("signups/ip", limit: 3, period: 1.hour) do |req|
    req.ip if graphql_operation_name(req) == "signUp"
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    retry_after = (req.env["rack.attack.match_data"] || {})[:period]
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [ { errors: [ { message: "Too many requests. Please retry later." } ] }.to_json ]
    ]
  end
end
