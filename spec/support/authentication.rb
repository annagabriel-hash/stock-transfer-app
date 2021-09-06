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

    def fill_in_signin_form(login_path, user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
  end

  module Stock
    def search_stock
      visit root_path
      fill_in 'Enter stock ticker symbol', with: 'MSFT'
      find_button('button').click
      expect(page).to have_content 'Microsoft Corporation'
    end
  end
end
