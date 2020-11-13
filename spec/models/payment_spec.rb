require 'rails_helper'

RSpec.describe 'Payment', type: :model do
  describe '#can_pay?' do
    it 'should return false if time passed' do
      user =  create :user
      vehicle = create :vehicle

      order = create :order, user: user, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, created_at: 11.minutes.ago
      payment = build :payment, user: user, order: order
      expect(payment.send(:can_pay?)).to eq false
    end

    it 'should return true if time not passed' do
      user =  create :user
      vehicle = create :vehicle

      order = create :order, user: user, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, created_at: 8.minutes.ago
      payment = build :payment, user: user, order: order
      expect(payment.send(:can_pay?)).to eq true
    end
  end

  describe '#check_order' do
    it 'should halt creation if order closed' do
      user =  create :user
      vehicle = create :vehicle

      order = create :order, user: user, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, created_at: 8.minutes.ago, status: :closed
      payment = build :payment, user: user, order: order
      expect(payment.valid?).to eq false
    end

    it 'should halt creation if order cancelled' do
      user = create :user
      vehicle = create :vehicle
      order = create :order, user: user, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, created_at: 8.minutes.ago, status: :cancelled
      payment = build :payment, user: user, order: order
      expect(payment.valid?).to eq false
    end

    it 'should halt creation if order paid' do
      user = create :user
      vehicle = create :vehicle
      order = create :order, user: user, vehicle: vehicle, starts_at: 3.days.since, expires_at: 4.days.since, created_at: 8.minutes.ago, status: :paid
      payment = build :payment, user: user, order: order
      expect(payment.valid?).to eq false
    end
  end
end
