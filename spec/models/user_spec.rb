# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:missions).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'should generates jti' do
      user = build(:user, jti: nil)
      user.save!
      expect(user.jti).to be_present
    end
  end

  describe 'devise modules' do
    it 'authenticates with valid password' do
      user = create(:user, password: 'testpassword123', password_confirmation: 'testpassword123')
      expect(user.valid_password?('testpassword123')).to be true
    end

    it 'rejects invalid password' do
      user = create(:user, password: 'testpassword123', password_confirmation: 'testpassword123')
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end
end
