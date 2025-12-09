# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mission Queries', type: :request do
  let!(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'missions' do
    let!(:mission1) { create(:mission, user: user, title: 'First', priority: 1, category: 'work') }
    let!(:mission2) { create(:mission, user: user, title: 'Second', priority: 3, category: 'personal', completed: true) }
    let!(:mission3) { create(:mission, user: user, title: 'Third', priority: 2, category: 'work') }
    let!(:other_mission) { create(:mission, title: 'Other user mission') }

    let(:query) do
      <<~GQL
        query Missions($input: MissionsQueryInput) {
          missions(input: $input) {
            id
            title
            priority
            completed
            category
          }
        }
      GQL
    end

    context 'when authenticated' do
      it "returns only user's missions" do
        graphql_request(query: query, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        expect(data.length).to eq(3)
        expect(data.map { |m| m['title'] }).not_to include('Other user mission')
      end

      it 'filters by completed status' do
        params = {
          input: { completed: true }
        }
        graphql_request(query: query, variables: params, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        expect(data.length).to eq(1)
        expect(data.first['title']).to eq('Second')
      end

      it 'filters by category' do
        params = {
          input: { category: 'work' }
        }
        graphql_request(query: query, variables: params, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        expect(data.length).to eq(2)
        expect(data.map { |m| m['category'] }).to all(eq('work'))
      end

      it 'searches by title' do
        params = {
          input: { search: 'First' }
        }
        graphql_request(query: query, variables: params, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        expect(data.length).to eq(1)
        expect(data.first['title']).to eq('First')
      end

      it 'sorts by priority descending' do
        params = {
          input: { sortBy: 'PRIORITY', sortOrder: 'DESC' }
        }
        graphql_request(query: query, variables: params, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        priorities = data.map { |m| m['priority'] }
        expect(priorities).to eq([ 3, 2, 1 ])
      end

      it 'limits results' do
        params = {
          input: { limit: 2 }
        }
        graphql_request(query: query, variables: params, headers: auth_headers)

        data = JSON.parse(response.body)['data']['missions']
        expect(data.length).to eq(2)
      end
    end

    context 'when not authenticated' do
      it 'should returns error' do
        graphql_request(query: query)

        result = JSON.parse(response.body)
        expect(result['errors'].first['message']).to eq('Not authenticated')
      end
    end
  end

  describe 'mission' do
    let!(:mission) { create(:mission, user: user, title: 'My Mission') }
    let(:query) do
      <<~GQL
        query Mission($id: ID!) {
          mission(id: $id) {
            id
            title
            description
          }
        }
      GQL
    end

    context 'when authenticated and owns mission' do
      it 'should returns the mission' do
        graphql_request(query: query, variables: { id: mission.id.to_s }, headers: auth_headers)

        data = JSON.parse(response.body)['data']['mission']
        expect(data['title']).to eq('My Mission')
      end
    end

    context 'when mission belongs to another user' do
      let!(:other_mission) { create(:mission, title: 'Other') }

      it 'should returns nil' do
        graphql_request(query: query, variables: { id: other_mission.id.to_s }, headers: auth_headers)

        data = JSON.parse(response.body)['data']['mission']
        expect(data).to be_nil
      end
    end
  end
end
