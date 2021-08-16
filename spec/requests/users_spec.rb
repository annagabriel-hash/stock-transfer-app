require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'GET /new' do
    before do
      get new_user_registration_path
    end

    it 'works' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders' do
      get new_user_registration_path
      expect(response).to render_template(:new)
    end
  end
end
