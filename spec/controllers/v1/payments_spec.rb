require 'rails_helper'

RSpec.describe 'V1::PaymentsController', type: :request do

  before do
    @v1 = create :vehicle, amount: 4
    @v2 = create :vehicle, amount: 2
    @v3 = create :vehicle, active: false
    @user = create :user
  end

  describe '#create' do
    it 'should create payment for users\' order' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400
      order2 = create :order, vehicle: @v1, starts_at: 7.days.since,  expires_at: 10.days.since, user: @user, amount: 8400
      order3 = create :order, vehicle: @v2, starts_at: 12.days.since, expires_at: 14.days.since, user: create(:user), amount: 8400
  
      expect {
        post '/v1/payments', params: {order_id: order1.id}, headers:  @user.create_new_auth_token
      }.to change(Payment, :count).by 1
      
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      payment = @user.payments.first

      expect(body).to eq({
        "id"=> payment.id,
        "amount"=>"8400.0",
        "created_at"=> payment.created_at.to_s
      })
    end

    it 'should not create payment if order closed' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400, status: :closed

      expect{
        post '/v1/payments', params: { order_id: order1.id }, headers: @user.create_new_auth_token
      }.to change(Payment, :count).by 0

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to eq({"status"=>"failed", "errors"=>["Order has already been closed"]})
    end

    it 'should not create payment if order closed' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400, status: :closed

      expect{
        post '/v1/payments', params: { order_id: order1.id }, headers: @user.create_new_auth_token
      }.to change(Payment, :count).by 0

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to eq({"status"=>"failed", "errors"=>["Order has already been closed"]})
    end

    it 'should not create payment if order closed' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400, status: :paid

      expect{
        post '/v1/payments', params: { order_id: order1.id }, headers: @user.create_new_auth_token
      }.to change(Payment, :count).by 0

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to eq({"status"=>"failed", "errors"=>["Your order has been paid. Do not resubmit the payment"]})
    end

    it 'should not create payment if order cancelled' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400, status: :cancelled

      expect{
        post '/v1/payments', params: { order_id: order1.id }, headers: @user.create_new_auth_token
      }.to change(Payment, :count).by 0

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to eq({"status"=>"failed", "errors"=>[ "Your order has been cancelled"]})
    end
  end
end
