require 'rails_helper'

RSpec.describe "ViewUsers", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let!(:buyer) { create(:user) }

  before do
    driven_by :rack_test
    sign_in admin_user
    visit admin_user_path(buyer)
  end

  it 'renders the user profile page when view button is clicked' do
    expect(page).to have_current_path(admin_user_path(buyer))
  end

  it 'view user information when view button is clicked', aggregate_failures: true do
    expect(page).to have_content(buyer.email)
    expect(page).to have_content(buyer.first_name)
    expect(page).to have_content(buyer.last_name)
    expect(page).to have_content(buyer.roles.first.name)
  end
end
