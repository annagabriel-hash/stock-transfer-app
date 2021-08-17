require 'rails_helper'

RSpec.describe 'CreateUsers', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # Fill in form
    fill_in_signup_form(build(:user))
  end

  context 'with valid inputs', :aggregate_failures do
    it 'saves the new user and display record' do
      expect { click_on 'Sign up' }.to change(User, :count).by(1)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Welcome! You have signed up successfully')
      expect(page).to have_content('John Doe')
    end
  end

  context 'without first name', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      fill_in 'First name', with: ' '
      expect { click_on 'Sign up' }.not_to change(User, :count)
      expect(page).to have_content('First name can\'t be blank')
    end
  end
end
