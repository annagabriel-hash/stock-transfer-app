require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'has full name attribute' do
    expect(create(:user).full_name).to eq('John Doe')
  end

  it 'is not valid without email' do
    expect(build(:user, email: ' ')).not_to be_valid
  end
end
