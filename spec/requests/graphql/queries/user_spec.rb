# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Queries', type: :request do
  let!(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'me' do
    let(:query) do
      <<~GQL
        query {
          me {
            id
            email
          }
        }
      GQL
    end

    context 'when authenticated' do
      it 'returns current user' do
        graphql_request(query: query, headers: auth_headers)

        data = JSON.parse(response.body)['data']['me']
        expect(data['email']).to eq(user.email)
      end
    end

    context 'when not authenticated' do
      it 'returns nil' do
        graphql_request(query: query)

        data = JSON.parse(response.body)['data']['me']
        expect(data).to be_nil
      end
    end
  end
end
