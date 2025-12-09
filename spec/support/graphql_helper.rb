# frozen_string_literal: true

module GraphqlHelper
  def graphql_request(query:, variables: {}, headers: {})
    post "/graphql",
      params: { query: query, variables: variables }.to_json,
      headers: { "Content-Type" => "application/json" }.merge(headers)
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include GraphqlHelper, type: :request
end
