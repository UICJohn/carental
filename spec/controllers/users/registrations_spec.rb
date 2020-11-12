require 'rails_helper'

RSpec.describe 'Users::RegistrationsController', type: :request do
  describe '#create' do
    it 'should create user by email' do
      expect do
        post '/auth', params: { username: 'Marsland', email: 'johntang@carental.com', password: '1234567' }
      end.to change(User, :count).by 1
      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body['data']['email']).to eq 'johntang@carental.com'
      expect(body['data']['username']).to eq 'Marsland'
    end

    it 'should not create user if email has been token' do
      user = create :user
      expect do
        post '/auth', params: { username: 'Marsland', email: user.email, password: '123141241' }
      end.to change(User, :count).by 0
      expect(response).to have_http_status(422)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_present
    end

    it 'should not create user if email is invalid' do
      expect do
        post '/auth', params: { username: 'Marsland', email: 'ab@c', password: '123141241' }
      end.to change(User, :count).by 0
      expect(response).to have_http_status(422)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_present
    end
  end
end
