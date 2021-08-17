require 'rails_helper'

RSpec.describe "ListUsers", type: :system do
  before do
    driven_by(:rack_test)
    user_list = build_list(:user, 10) do |user, i|
      user.email = "person#{i}@example.com"
      user.save
    end
    sign_in user_list.first
    visit users_path
  end

  it 'displays all registered users' do
    within 'tbody' do
      expect(page).to have_selector('tr', count: 10)
    end
  end
end
