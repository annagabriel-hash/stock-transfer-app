require 'rails_helper'

RSpec.describe 'ListUsers', type: :system do
  let!(:user_list) do
    create(:role)
    build_list(:user, 10) do |user, i|
      user.email = "person#{i}@example.com"
      user.save!
    end
  end

  before do
    driven_by(:rack_test)
    admin_user = create(:user, :admin)
    sign_in admin_user
    visit admin_users_path
  end

  it 'displays all registered users' do
    within 'tbody' do
      expect(page).to have_selector('tr', count: 11)
    end
  end

  it 'shows edit user page when edit button is clicked' do
    find_link('Edit', href: edit_user_registration_path(user_list.second)).click
    expect(page).to have_current_path(edit_user_registration_path(user_list.second))
  end

  it 'view user information when view button is clicked' do
    find_link('View', href: admin_user_path(user_list.second)).click
    expect(page).to have_current_path(admin_user_path(user_list.second))
  end
end
