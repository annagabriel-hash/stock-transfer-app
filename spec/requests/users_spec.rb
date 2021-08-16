require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET /index' do
    before do
      get users_path
    end

    it 'works' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /new' do
    before do
      get new_user_registration_path
    end

    it 'works' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    let(:created_user) { User.find_by(email: 'johndoe@example.com') }

    before do
      post user_registration_path(build(:user)), params: { user: { first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com', password: 'password', password_confirmation: 'password' } }
    end

    it 'is works' do
      expect(response).to have_http_status(:redirect)
    end

    it 'creates new user with email' do
      created_user = User.where({ email: 'johndoe@example.com' })
      expect(created_user).to exist
    end

    it 'creates new user with first name' do
      expect(created_user.first_name).to eq('John')
    end

    it 'creates new user with last name' do
      expect(created_user.last_name).to eq('Doe')
    end
  end
end
