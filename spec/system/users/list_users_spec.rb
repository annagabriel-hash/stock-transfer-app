require 'rails_helper'

RSpec.describe 'ListUsers', type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:buyer_user) { create(:user) }
  let!(:user_list) do
    create(:role)
    broker = create(:role, :broker)
    build_list(:user, 10) do |user, i|
      user.email = "person#{i}@example.com"
      user.roles.push(broker) if i == 1
      user.save!
    end
  end

  before do
    driven_by(:rack_test)
    sign_in admin_user
    visit admin_users_path
  end

  context 'when admin user is logged in' do
    it 'displays all registered users' do
      expected_regex = /#{User.all.map(&:email).join('.*')}/
      expect(page).to have_text(expected_regex)
    end

    it 'shows edit user page when edit button is clicked' do
      find_link('Edit', href: edit_admin_user_path(user_list.second)).click
      expect(page).to have_current_path(edit_admin_user_path(user_list.second))
    end

    it 'view user information when view button is clicked' do
      find_link('View', href: admin_user_path(user_list.second)).click
      expect(page).to have_current_path(admin_user_path(user_list.second))
    end

    it 'disables approve button when user status is approved', aggregate_failures: true do
      expect(user_list.first.status).to eq('approved')
      expect(page).not_to have_link('Approve', href: admin_user_approve_path(user_list.first))
    end

    it 'approves broker when approve button is clicked' do
      expect do
        find_link('Approve', href: admin_user_approve_path(user_list.second)).click
      end.to change { user_list.second.reload.status }.to('approved')
    end
  end

  context 'when admin user is not logged in' do
    it 'cannot display user list' do
      sign_out admin_user
      visit admin_users_path
      expect(page).not_to have_current_path(admin_users_path)
    end
  end

  context 'when user is not an admin' do
    it 'cannot display user list' do
      sign_out admin_user
      sign_in buyer_user
      visit admin_users_path
      expect(page).not_to have_current_path(admin_users_path)
    end
  end
end
