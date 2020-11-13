require 'rails_helper'

RSpec.describe 'VehiclesSearch', type: :model do
  before do
    @user = create :user
    @store = create :store
    @store1 = create :store
    @v1 = create :vehicle, amount: 2, store: @store
    @v2 = create :vehicle, amount: 1, store: @store
    @v3 = create :vehicle, active: false
    @v4 = create :vehicle, amount: 3, store: @store1
  end

  describe '#search' do
    it 'should search available vehicle for store' do
      order1 = create :order, vehicle: @v1, starts_at: 5.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 2.days.since, expires_at: 10.days.since
      result = VehiclesSearch.new({ pick_up_store_id: @store.id, starts_at: 3.days.since, expires_at: 8.days.since }).search
      expect(result.count).to eq 1
      expect(result.first).to eq @v2
    end

    it 'should search available vehicle for store' do
      order1 = create :order, vehicle: @v1, starts_at: 6.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 5.days.since, expires_at: 10.days.since
      result = VehiclesSearch.new({ pick_up_store_id: @store.id, starts_at: 1.day.since, expires_at: 4.days.since }).search
      expect(result.count).to eq 2
      expect(result).to eq [@v1, @v2]
    end

    it 'should search available vehicle for store' do
      order1 = create :order, vehicle: @v1, starts_at: 6.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 12.days.since, expires_at: 14.days.since
      result = VehiclesSearch.new({ pick_up_store_id: @store.id, starts_at: 7.days.since, expires_at: 10.days.since }).search
      expect(result.count).to eq 2
      expect(result).to eq [@v1, @v2]
    end

    it 'should search available vehicle for store' do
      order1 = create :order, vehicle: @v1, starts_at: 6.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 12.days.since, expires_at: 14.days.since
      result = VehiclesSearch.new({ pick_up_store_id: @store.id, starts_at: 7.days.since, expires_at: 13.days.since }).search
      expect(result.count).to eq 2
      expect(result).to eq [@v1, @v2]
    end

    it 'should search available vehicle for store' do
      order1 = create :order, vehicle: @v1, starts_at: 6.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 12.days.since, expires_at: 14.days.since
      result = VehiclesSearch.new({ pick_up_store_id: @store1.id, starts_at: 7.days.since, expires_at: 13.days.since }).search
      expect(result.count).to eq 1
      expect(result).to eq [@v4]
    end

    it 'should search available vehicle' do
      order1 = create :order, vehicle: @v1, starts_at: 6.days.since, expires_at: 10.days.since
      order2 = create :order, vehicle: @v1, starts_at: 12.days.since, expires_at: 14.days.since
      result = VehiclesSearch.new.search
      expect(result.count).to eq 3
      expect(result).to eq [@v1, @v2, @v4]
    end
  end
end
