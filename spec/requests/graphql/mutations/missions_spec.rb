# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mission Mutations', type: :request do
  let!(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'create_mission' do
    let(:query) do
      <<~GQL
        mutation CreateMission($input: CreateMissionInput!) {
          createMission(input: $input) {
            mission { id title description priority category completed }
            errors
          }
        }
      GQL
    end

    context 'when authenticated' do
      let(:variables) do
        {
          input: {
            title: 'New Mission',
            description: 'Description here',
            priority: 2,
            category: 'work'
          }
        }
      end

      it 'should creates a mission success' do
        expect {
          graphql_request(query: query, variables: variables, headers: auth_headers)
        }.to change(Mission, :count).by(1)

        data = JSON.parse(response.body)['data']['createMission']
        expect(data['mission']['title']).to eq('New Mission')
        expect(data['mission']['priority']).to eq(2)
        expect(data['errors']).to be_empty
      end
    end

    context 'when not authenticated' do
      let(:variables) { { input: { title: 'Test' } } }

      it 'returns error' do
        graphql_request(query: query, variables: variables)

        result = JSON.parse(response.body)
        if result['data'] && result['data']['createMission']
          expect(result['data']['createMission']['errors']).to include('Not authenticated')
        else
          expect(result['errors'].first['message']).to eq('Not authenticated')
        end
      end
    end

    context 'with invalid data' do
      let(:variables) do
        { input: { title: '', priority: 5 } }
      end

      it 'returns validation errors' do
        graphql_request(query: query, variables: variables, headers: auth_headers)

        data = JSON.parse(response.body)['data']['createMission']
        expect(data['mission']).to be_nil
        expect(data['errors']).not_to be_empty
      end
    end
  end

  describe 'update_mission' do
    let!(:mission) { create(:mission, user: user, title: 'Original Title') }
    let(:query) do
      <<~GQL
        mutation UpdateMission($input: UpdateMissionInput!) {
          updateMission(input: $input) {
            mission { id title completed }
            errors
          }
        }
      GQL
    end

    context 'when authenticated and owns mission' do
      let(:variables) do
        { input: { id: mission.id.to_s, title: 'Updated Title', completed: true } }
      end

      it 'updates the mission' do
        graphql_request(query: query, variables: variables, headers: auth_headers)

        data = JSON.parse(response.body)['data']['updateMission']
        expect(data['mission']['title']).to eq('Updated Title')
        expect(data['mission']['completed']).to be true
        expect(mission.reload.title).to eq('Updated Title')
      end
    end

    context 'when mission belongs to another user' do
      let(:other_user) { create(:user) }
      let!(:other_mission) { create(:mission, user: other_user) }
      let(:variables) do
        { input: { id: other_mission.id.to_s, title: 'Hacked' } }
      end

      it 'returns not found error' do
        graphql_request(query: query, variables: variables, headers: auth_headers)

        data = JSON.parse(response.body)['data']['updateMission']
        expect(data['mission']).to be_nil
        expect(data['errors']).to include('Mission not found')
      end
    end
  end

  describe 'delete_mission' do
    let!(:mission) { create(:mission, user: user) }
    let(:query) do
      <<~GQL
        mutation DeleteMission($id: ID!) {
          deleteMission(id: $id) {
            success
            errors
          }
        }
      GQL
    end

    context 'when authenticated and owns mission' do
      let(:variables) { { id: mission.id.to_s } }

      it 'deletes the mission' do
        expect {
          graphql_request(query: query, variables: variables, headers: auth_headers)
        }.to change(Mission, :count).by(-1)

        data = JSON.parse(response.body)['data']['deleteMission']
        expect(data['success']).to be true
      end
    end

    context 'when mission not found' do
      let(:variables) { { id: '99999' } }

      it 'returns error' do
        graphql_request(query: query, variables: variables, headers: auth_headers)

        data = JSON.parse(response.body)['data']['deleteMission']
        expect(data['success']).to be false
        expect(data['errors']).to include('Mission not found')
      end
    end
  end
end
