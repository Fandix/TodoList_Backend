# frozen_string_literal: true

class Rack::Attack
  # cache
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # 100 times / 1 minute limit
  throttle("req/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path == "/graphql"
  end

  # login 5 minute 5 times limit
  throttle("logins/ip", limit: 5, period: 5.minutes) do |req|
    if req.path == "/graphql" && req.post?
      body = req.body.read
      req.body.rewind
      req.ip if body.include?("signIn")
    end
  end

  # singup 3 times in 1 hour limit
  throttle("signups/ip", limit: 3, period: 1.hour) do |req|
    if req.path == "/graphql" && req.post?
      body = req.body.read
      req.body.rewind
      req.ip if body.include?("signUp")
    end
  end

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
