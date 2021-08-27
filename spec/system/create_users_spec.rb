require 'rails_helper'

RSpec.describe 'CreateUsers', type: :system do
  before do
    driven_by(:rack_test)
    create(:role)
    create(:role, :admin)
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
      expect(page).to have_content('Sign up')
    end
  end

  context 'without email', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      fill_in 'Email', with: ' '
      expect { click_on 'Sign up' }.not_to change(User, :count)
      expect(page).to have_content('Email can\'t be blank')
      expect(page).to have_content('Sign up')
    end
  end

  context 'with duplicate email', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      create(:user)
      fill_in 'First name', with: 'Jane'
      expect { click_on 'Sign up' }.not_to change(User, :count)
      expect(page).to have_content('Email has already been taken')
      expect(page).to have_content('Sign up')
    end
  end

  context 'with password confirmation not matching with password', :aggregate_failures do
    it 'generates an error message and render sign in page' do
      fill_in 'Password confirmation', with: 'notmatch'
      expect { click_on 'Sign up' }.not_to change(User, :count)
      expect(page).to have_content('Password confirmation doesn\'t match Password')
      expect(page).to have_content('Sign up')
    end
  end

  context 'without roles' do
    it 'assigns buyer role' do
      click_on 'Sign up'
      user = User.find_by(email: 'johndoe@example.com')
      default_role = Role.find_by(name: 'buyer')
      expect(user.roles).to match_array([default_role])
    end

    it 'assigns user status to approved' do
      click_on 'Sign up'
      user = User.find_by(email: 'johndoe@example.com')
      expect(user.status).to eq('approved')
    end

    it 'welcome email is sent', :aggregate_failures do
      expect { click_on 'Sign up' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq 'Welcome to the Stock App'
    end

    it 'welcome email is sent to the right user' do
      click_on 'Sign up'
      mail = ActionMailer::Base.deliveries.last
      user = User.find_by(email: 'johndoe@example.com')
      expect(mail.to[0]).to eq user.email
    end
  end
end
