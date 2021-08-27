require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:buyer_user) { create(:user) }

  describe 'GET /admin/index' do
    context 'when admin user is logged in' do
      before do
        sign_in admin_user
        get admin_users_path
      end

      it 'works' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders' do
        expect(response).to render_template(:index)
      end

      it 'assigns users' do
        expect(assigns(:users)).to eq(User.all)
      end
    end

    context 'when user is not an admin' do
      before do
        create(:role, :admin)
        user = create(:user)
        sign_in user
        get admin_users_path
      end

      it 'does not work' do
        expect(response).to have_http_status(:redirect)
      end

      it 'generates an error message' do
        expect(flash[:alert]).to be_present
      end
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
      create(:role)
      post user_registration_path(build(:user)), params: { user: { first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com', password: 'password', password_confirmation: 'password' } }
    end

    it 'works' do
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

  describe 'GET /edit' do
    before do
      sign_in admin_user
      get edit_admin_user_path(buyer_user)
    end

    it 'works' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders' do
      expect(response).to render_template(:edit)
    end

    it 'assigns user' do
      expect(assigns(:user)).to eq(buyer_user)
    end
  end

  describe 'GET /verify' do
    let(:mail) { instance_double(UserMailer) }

    before do
      allow(UserMailer).to receive(:verify_email).and_call_original
      sign_in buyer_user
      get user_verify_path(buyer_user)
    end

    it 'works' do
      expect(response).to have_http_status(:redirect)
    end

    it 'sends email to user' do
      expect(UserMailer).to have_received(:verify_email).once
    end
  end

  describe 'PATCH /confirm' do
    let!(:broker_role) { create(:role, :broker) }

    before do
      sign_in buyer_user
      patch user_confirm_path(buyer_user.id), params: { id: buyer_user.id }
    end

    it 'works' do
      expect(response).to have_http_status(:success)
    end

    it 'adds buyer role' do
      expect(buyer_user.reload.roles).to include broker_role
    end
  end
end
