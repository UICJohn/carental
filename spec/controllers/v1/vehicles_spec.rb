require 'rails_helper'

RSpec.describe 'V1::VehiclesController', type: :request do
  before do
    @user = create :user
    @store = create :store
    @v1 = create :vehicle, amount: 2, store: @store
    @v2 = create :vehicle, amount: 1, store: @store
    @v3 = create :vehicle, active: false
  end

  describe '#index' do
    it 'should return all active vehicles' do
      get '/v1/vehicles'
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body.count).to eq 2
      expect(body).to eq [
        {
          'id' => @v1.id,
          'price' => '1200.0',
          'amount' => 2,
          'color' => nil,
          'model' => 'xc90',
          'brand' => 'volvo',
          'store' => {
            'id' => @v1.store_id,
            'name' => 'Budget',
            'address' => nil,
            'country' => 'China',
            'state' => 'Guangdong',
            'city' => 'Shengzhen'
          }
        },
        {
          'id' => @v2.id,
          'price' => '1200.0',
          'amount' => 1,
          'color' => nil,
          'model' => 'xc90',
          'brand' => 'volvo',
          'store' => {
            'id' => @v2.store_id,
            'name' => 'Budget',
            'address' => nil,
            'country' => 'China',
            'state' => 'Guangdong',
            'city' => 'Shengzhen'
          }
        }
      ]
    end

    it 'should search for vehicles' do
      create :order, vehicle: @v1, user: @user, starts_at: 1.day.since, expires_at: 11.days.since
      create :order, vehicle: @v2, user: (create :user), starts_at: 2.days.since, expires_at: 11.days.since

      get '/v1/vehicles', params: { pick_up_store_id: @store.id, starts_at: 2.days.since, expires_at: 15.days.since }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to eq([{
                           'id' => @v1.id,
                           'price' => '1200.0',
                           'amount' => 2,
                           'color' => nil,
                           'model' => 'xc90',
                           'brand' => 'volvo',
                           'store' => {
                             'id' => @store.id,
                             'name' => 'Budget',
                             'address' => nil,
                             'country' => 'China',
                             'state' => 'Guangdong',
                             'city' => 'Shengzhen'
                           }
                         }])
    end
  end

  describe '#show' do
    it 'should return vehicle with id' do
      get "/v1/vehicles/#{@v1.id}"
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq({
                           'id' => @v1.id,
                           'price' => '1200.0',
                           'amount' => 2,
                           'color' => nil,
                           'model' => {
                             'brand' => 'volvo',
                             'name' => 'xc90',
                             'year' => '2000'
                           },
                           'store' => {
                             'id' => @v1.store_id,
                             'name' => 'Budget',
                             'address' => nil,
                             'country' => 'China',
                             'state' => 'Guangdong',
                             'city' => 'Shengzhen'
                           }
                         })
    end
  end
end
