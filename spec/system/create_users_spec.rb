require 'rails_helper'

RSpec.describe 'CreateUsers', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # Fill in form
    fill_in_signup_form(build(:user))
  end

  context 'with valid inputs', :aggregate_failures do
    it 'saves the new user and display record' do
      expect { click_on 'Create Account' }.to change(User, :count).by(1)
      expect(page).to have_current_path(user_path)
      expect(page).to have_content('Account was created succesfully')
      expect(page).to have_content('John Doe')
    end
  end
end
