require 'rails_helper'

RSpec.describe 'VerifyUsers', type: :system do
  let(:buyer_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  before do
    driven_by(:rack_test)
  end

  context 'when buyer user verifies account' do
    before do
      admin_user
      sign_in buyer_user
      visit root_path
      ActionMailer::Base.deliveries.clear
    end

    it 'has verify account link' do
      expect(page).to have_link('Verify account', href: user_confirm_path(buyer_user))
    end

    it 'sends verify email', :aggregate_failures do
      expect do
        find_link('Verify account', href: user_confirm_path(buyer_user)).click
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Stock App - Verify account'
    end
  end

  context 'when admin user approves account' do
    before do
      create(:role, :broker)
      buyer_user.upgrade_account
      patch user_confirm_path(buyer_user.id), params: { id: buyer_user.id }
      sign_in admin_user
      visit root_path
    end

    it 'has verify account link' do
      expect(page).not_to have_link('Verify account', href: user_confirm_path(buyer_user))
    end

    it 'user status changes to approve' do
      find_link('User Management', href: admin_users_path).click
      expect do
        find_link('Approve', href: admin_user_approve_path(buyer_user)).click
      end.to change { buyer_user.reload.status }.to('approved')
    end

    it 'sends email to user', :aggregate_failures do
      find_link('User Management', href: admin_users_path).click
      expect do
        find_link('Approve', href: admin_user_approve_path(buyer_user)).click
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'sends correct email to user', :aggregate_failures do
      find_link('User Management', href: admin_users_path).click
      find_link('Approve', href: admin_user_approve_path(buyer_user)).click
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Stock App - Account successfully verified'
    end
  end
end
