require 'rails_helper'

RSpec.describe 'V1::VehiclesController', type: :request do
  before do
    @v1 = create :vehicle
    @v2 = create :vehicle
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
          'amount' => 2,
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
