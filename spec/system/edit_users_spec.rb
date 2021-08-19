require 'rails_helper'

RSpec.describe 'EditUsers', type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    driven_by :selenium, using: :chrome
    create(:role, :broker)
    sign_in admin_user
    visit edit_admin_user_path(user)
  end

  context 'with valid inputs', :aggregate_failures do
    it 'updates the new user' do
      fill_in 'First name', with: 'Philip'
      check 'broker'
      click_on 'Update User'
      expect(User.find(user.id).first_name).to eq('Philip')
      expect(page).to have_content('You have successfully update the user')
    end
  end

  context 'without first name', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      fill_in 'First name', with: ' '
      click_on 'Update User'
      expect(page).to have_content('First name can\'t be blank')
    end
  end

  context 'without email', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      fill_in 'Email', with: ' '
      click_on 'Update User'
      expect(page).to have_content('Email can\'t be blank')
    end
  end

  context 'when user is not an admin' do
    it 'cannot edit user' do
      sign_out admin_user
      sign_in user
      visit edit_admin_user_path(user)
      expect(page).not_to have_current_path(edit_admin_user_path(user))
    end
  end
end
