# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth Mutations', type: :request do
  describe 'signUp' do
    let(:query) do
      <<~GQL
        mutation SignUp($email: String!, $password: String!, $passwordConfirmation: String!) {
          signUp(email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            user { id email }
            token
            errors
          }
        }
      GQL
    end

    context 'with valid params' do
      let(:variables) do
        {
          email: 'newuser@example.com',
          password: 'password123',
          passwordConfirmation: 'password123'
        }
      end

      it 'creates a new user and returns token' do
        expect {
          graphql_request(query: query, variables: variables)
        }.to change(User, :count).by(1)

        data = JSON.parse(response.body)['data']['signUp']
        expect(data['user']['email']).to eq('newuser@example.com')
        expect(data['token']).to be_present
      end
    end

    context 'with invalid params' do
      let(:variables) do
        {
          email: 'invalid_email',
          password: '123',
          passwordConfirmation: '456'
        }
      end

      it 'returns errors' do
        graphql_request(query: query, variables: variables)

        data = JSON.parse(response.body)['data']['signUp']
        expect(data['user']).to be_nil
        expect(data['token']).to be_nil
        expect(data['errors']).not_to be_empty
      end
    end
  end

  describe 'signIn' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
    let(:query) do
      <<~GQL
        mutation SignIn($email: String!, $password: String!) {
          signIn(email: $email, password: $password) {
            user { id email }
            token
            errors
          }
        }
      GQL
    end

    context 'with valid credentials' do
      let(:variables) do
        { email: 'test@example.com', password: 'password123' }
      end

      it 'returns user and token' do
        graphql_request(query: query, variables: variables)

        data = JSON.parse(response.body)['data']['signIn']
        expect(data['user']['email']).to eq('test@example.com')
        expect(data['token']).to be_present
      end
    end

    context 'with not correct email and password' do
      let(:variables) do
        { email: 'test@example.com', password: 'wrongpassword' }
      end

      it 'returns error' do
        graphql_request(query: query, variables: variables)

        data = JSON.parse(response.body)['data']['signIn']
        expect(data['user']).to be_nil
        expect(data['token']).to be_nil
        expect(data['errors']).to include('Invalid email or password')
      end
    end
  end

  describe 'signOut' do
    let!(:user) { create(:user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
    let(:query) do
      <<~GQL
        mutation {
          signOut {
            success
            errors
          }
        }
      GQL
    end

    context 'when authenticated' do
      it 'should logout success' do
        old_jti = user.jti

        graphql_request(
          query: query,
          headers: { 'Authorization' => "Bearer #{token}" }
        )

        data = JSON.parse(response.body)['data']['signOut']
        expect(data['success']).to be true
      end
    end

    context 'when not authenticated' do
      it 'returns error' do
        graphql_request(query: query)

        data = JSON.parse(response.body)['data']['signOut']
        expect(data['success']).to be false
        expect(data['errors']).to include('Not authenticated')
      end
    end
  end
end
