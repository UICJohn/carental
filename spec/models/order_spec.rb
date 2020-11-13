require 'rails_helper'

RSpec.describe 'Order', type: :model do
  before do
    CheckPaymentWorker.clear
  end

  describe '#initialize_order_for' do
    it 'should create order for user' do
      user =  create :user
      vehicle = create :vehicle

      expect  do
        Order.initialize_order_for(user, { vehicle_id: vehicle.id, starts_at: 3.days.since, expires_at: 4.days.since })
      end.to change(user.orders, :count).by 1

      expect(CheckPaymentWorker.jobs.count).to eq 1
      expect(CheckPaymentWorker.jobs.first['args']).to eq [user.orders.first.id]
    end
  end

  describe '#validate' do
    it 'should not create order if vehicle out of stock' do
      user = create :user
      user2 = create :user
      user3 = create :user
      vehicle = create :vehicle, amount: 2

      Order.initialize_order_for(user, { vehicle_id: vehicle.id, starts_at: 3.days.since, expires_at: 4.days.since })
      Order.initialize_order_for(user2, { vehicle_id: vehicle.id, starts_at: 3.days.since, expires_at: 4.days.since })
      Order.initialize_order_for(user, { vehicle_id: vehicle.id, starts_at: 2.days.since, expires_at: 4.days.since })

      expect(vehicle.orders.count).to eq 2
      expect(vehicle.orders.find_by(user_id: user.id)).to be_present
      expect(vehicle.orders.find_by(user_id: user2.id)).to be_present
      expect(vehicle.orders.find_by(user_id: user3.id)).not_to be_present
    end
  end

  describe '#cancel!' do
    it 'should cancel order' do
      vehicle = create :vehicle
      user = create :user
      order = create :order, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, user: user

      order.cancel!
      expect(order.status).to eq 'cancelled'
    end
  end

  describe '#pay_before' do
    it 'should return pay before timestamp' do
      vehicle = create :vehicle
      user = create :user
      order = create :order, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, user: user
      expect(order.pay_before).to eq 10.minutes.since(order.created_at)
    end
  end
end
