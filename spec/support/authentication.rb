module Helpers
  module Authentication
    def fill_in_signup_form(user)
      visit new_user_registration_path
      fill_in 'First name', with: user.first_name
      fill_in 'Last name', with: user.last_name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
    end
  end
end
