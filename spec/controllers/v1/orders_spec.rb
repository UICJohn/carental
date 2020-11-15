require 'rails_helper'

RSpec.describe 'V1::OrdersController', type: :request do
  before do
    @v1 = create :vehicle, amount: 4
    @v2 = create :vehicle, amount: 2
    @v3 = create :vehicle, active: false
    @user = create :user
  end

  describe '#index' do
    it 'should return users\' order' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400
      order2 = create :order, vehicle: @v1, starts_at: 7.days.since,  expires_at: 10.days.since, user: @user, amount: 8400
      order3 = create :order, vehicle: @v2, starts_at: 12.days.since, expires_at: 14.days.since, user: create(:user), amount: 8400

      get '/v1/orders', headers: @user.create_new_auth_token

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq [
        {
          'id' => order1.id,
          'created_at' => order1.created_at.to_s,
          'starts_at' => order1.starts_at.to_s,
          'expires_at' => order1.expires_at.to_s,
          'amount' => '8400.0'
        },
        {
          'id' => order2.id,
          'created_at' => order2.created_at.to_s,
          'starts_at' => order2.starts_at.to_s,
          'expires_at' => order2.expires_at.to_s,
          'amount' => '8400.0'
        }
      ]
    end
  end

  describe '#index' do
    it 'should return users\' order' do
      order1 = create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: @user, amount: 8400
      order2 = create :order, vehicle: @v1, starts_at: 7.days.since,  expires_at: 10.days.since, user: @user, amount: 8400
      order3 = create :order, vehicle: @v2, starts_at: 12.days.since, expires_at: 14.days.since, user: create(:user), amount: 8400

      get "/v1/orders/#{order1.id}", headers: @user.create_new_auth_token

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq({
                           'id' => order1.id,
                           'amount' => '8400.0',
                           'created_at' => order1.created_at.to_s,
                           'starts_at' => order1.starts_at.to_s,
                           'expires_at' => order1.expires_at.to_s,
                           'vehicle' => {
                             'price' => '1200.0',
                             'color' => nil
                           },
                           'store' => {
                             'id' => order1.store.id,
                             'name' => 'Budget',
                             'address' => nil,
                             'country' => 'China',
                             'state' => 'Guangdong',
                             'city' => 'Shengzhen'
                           }
                         })
    end
  end

  describe '#create' do
    it 'should not create new order for anonymity user' do
      expect do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: 3.days.since, expires_at: 10.days.since }
      end.to change(Order, :count).by 0
      expect(response).to have_http_status(401)
    end

    it 'should create new order for user' do
      starts_at = 3.days.since
      expires_at = 10.days.since

      # expect do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: starts_at, expires_at: expires_at }, headers: @user.create_new_auth_token
      # end.to change(Order, :count).by 1

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      order = Order.find_by(user_id: @user.id)

      expect(body).to eq({
                           'id' => order.id,
                           'created_at' => order.created_at.to_s,
                           'starts_at' => starts_at.to_s,
                           'expires_at' => expires_at.to_s,
                           'amount' => '8400.0',
                           'status' => 'pending',
                           'pay_before' => order.pay_before.to_s,
                           'vehicle' => {
                             'price' => '1200.0',
                             'color' => nil
                           },
                           'store' => {
                             'id' => order.store.id,
                             'name' => 'Budget',
                             'address' => nil,
                             'country' => 'China',
                             'state' => 'Guangdong',
                             'city' => 'Shengzhen'
                           }
                         })
    end

    it 'should not create order if user have another order within start date and end date' do
      order = create :order, starts_at: 2.days.since, expires_at: 5.days.since, user: @user

      expect  do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: 2.days.since, expires_at: 6.days.since }, headers: @user.create_new_auth_token
      end.to change(Order, :count).by 0

      expect do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: 1.day.since, expires_at: 6.days.since }, headers: @user.create_new_auth_token
      end.to change(Order, :count).by 0

      expect do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: 3.days.since, expires_at: 4.days.since }, headers:  @user.create_new_auth_token
      end.to change(Order, :count).by 0

      order.cancel!

      expect do
        post '/v1/orders', params: { vehicle_id: @v1.id, starts_at: 3.days.since, expires_at: 4.days.since }, headers:  @user.create_new_auth_token
      end.to change(Order, :count).by 1

      body = JSON.parse(response.body)
    end

    it 'should not create order if out of stock' do
      travel_to(Time.new(2020, 11, 13))

      create :order, vehicle: @v2, starts_at: 2.days.since,  expires_at: 6.days.since,  user: create(:user)
      create :order, vehicle: @v2, starts_at: 4.days.since,  expires_at: 10.days.since, user: create(:user)
      create :order, vehicle: @v2, starts_at: 12.days.since, expires_at: 14.days.since, user: create(:user)

      expect do
        post '/v1/orders', params: { vehicle_id: @v2.id, starts_at: 4.days.since, expires_at: 14.days.since }, headers: @user.create_new_auth_token
      end.to change(Order, :count).by 0

      body = JSON.parse(response.body)

      expect(body).to eq({ 'status' => 'failed', 'errors' => ['Vehicle out of stock at 2020-11-17', 'Vehicle out of stock at 2020-11-18'] })
    end

    it 'should not create order if expires_at before starts_at' do
      expect do
        post '/v1/orders', params: { vehicle_id: @v2.id, starts_at: 4.days.since, expires_at: 3.days.since }, headers: @user.create_new_auth_token
      end.to change(Order, :count).by 0

      body = JSON.parse(response.body)
      expect(body).to eq({ 'status' => 'failed', 'errors' => ['Expires at expires date cannot before pick up date'] })
    end

    it 'should not create order if starts_at before today' do
      expect do
        post '/v1/orders', params: { vehicle_id: @v2.id, starts_at: 2.days.ago, expires_at: 3.days.since }, headers: @user.create_new_auth_token
      end.to change(Order, :count).by 0

      body = JSON.parse(response.body)
      expect(body).to eq({ 'status' => 'failed', 'errors' => ['Starts at invalid start date'] })
    end
  end

  describe '#delete' do
    it 'should not allow user to cancelled the payment if only 1 day left for user to pick up the car' do
      order = create :order, vehicle: @v2, starts_at: 23.hours.since, expires_at: 6.days.since, user: @user
      expect do
        delete "/v1/orders/#{order.id}", headers: @user.create_new_auth_token
      end.not_to change(order, :status)

      order.reload
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq({ 'status' => 'failed', 'errors' => 'Sorry, we cannot cancel your order' })
    end

    it 'should allow user to cancelled the payment if more than 1 day left for user to pick up the car' do
      order = create :order, vehicle: @v2, starts_at: 2.days.since, expires_at: 6.days.since, user: @user
      delete "/v1/orders/#{order.id}", headers: @user.create_new_auth_token
      order.reload
      expect(order.status).to eq 'cancelled'
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq({ 'status' => 'success' })
    end
  end
end
