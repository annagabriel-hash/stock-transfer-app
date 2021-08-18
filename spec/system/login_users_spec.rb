require 'rails_helper'

RSpec.describe 'LoginUsers', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    visit new_user_session_path
  end

  it 'can access login page' do
    expect(page).to have_current_path(new_user_session_path)
  end

  context 'with valid email and password' do
    it 'can access user account display success message' do
      # Fill in login details
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end
  end
end
