# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mission, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:completed_mission) { create(:mission, :completed, user: user) }
    let!(:pending_mission) { create(:mission, completed: false, user: user) }
    let!(:high_priority_mission) { create(:mission, :high_priority, user: user) }

    describe '.completed' do
      it 'returns only completed missions' do
        expect(Mission.completed).to include(completed_mission)
      end
    end

    describe '.pending' do
      it 'returns only pending missions' do
        expect(Mission.pending).to include(pending_mission)
      end
    end

    describe '.by_priority' do
      it 'orders by priority descending' do
        expect(Mission.by_priority.first).to eq(high_priority_mission)
      end
    end
  end
end
