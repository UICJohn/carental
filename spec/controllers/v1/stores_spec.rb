require 'rails_helper'

RSpec.describe 'V1::StoresController', type: :request do
  before do
  end

  describe '#index' do
    it 'should return all store' do
      s = create :store
      s1 = create :store
      get '/v1/stores'
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body.count).to eq 2
      expect(body).to eq [
        {
          'id' => s.id,
          'name' => 'Budget',
          'address' => nil,
          'country' => 'China',
          'state' => 'Guangdong',
          'city' => 'Shengzhen'
        },
        {
          'id' => s1.id,
          'name' => 'Budget',
          'address' => nil,
          'country' => 'China',
          'state' => 'Guangdong',
          'city' => 'Shengzhen'
        }
      ]
    end
  end
end
