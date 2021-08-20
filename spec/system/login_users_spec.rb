require 'rails_helper'

RSpec.describe 'LoginUsers', type: :system do
  let(:user) { create(:user) }
  let(:random_user) { build(:random_user) }

  before do
    driven_by :selenium, using: :chrome
    create(:role, :admin)
  end

  it 'can access login page' do
    fill_in_signin_form(new_user_session_path, user)
    expect(page).to have_current_path(new_user_session_path)
  end

  context 'with valid email and password' do
    it 'can access user account' do
      fill_in_signin_form(new_user_session_path, user)
      click_on 'Log in'
      expect(page).to have_content(user.first_name)
    end

    it 'display success message' do
      fill_in_signin_form(new_user_session_path, user)
      click_on 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end
  end

  context 'with invalid email' do
    it 'cannot access account' do
      fill_in_signin_form(new_user_session_path, random_user)
      click_on 'Log in'
      expect(page).not_to have_content(random_user.first_name)
    end

    it 'display error message' do
      fill_in_signin_form(new_user_session_path, random_user)
      click_on 'Log in'
      expect(page).to have_content('Invalid Email or password')
    end
  end

  context 'with invalid password' do
    it 'cannot access account' do
      fill_in_signin_form(new_user_session_path, user)
      fill_in 'Password', with: 'fakepassword'
      click_on 'Log in'
      expect(page).not_to have_content(user.first_name)
    end

    it 'display error message' do
      # Fill in login details
      fill_in_signin_form(new_user_session_path, user)
      fill_in 'Password', with: 'fakepassword'
      click_on 'Log in'
      expect(page).to have_content('Invalid Email or password')
    end
  end
end
