module Helpers
  module Authentication
    def fill_in_signup_form(user)
      visit new_user_registration_path
      fill_in 'First Name', with: user.first_name
      fill_in 'Last Name', with: user.last_name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      fill_in 'Confirm Password', with: 'password'
    end
  end
end