require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:user, :buyer)).to be_valid
  end

  it 'has full name attribute' do
    expect(create(:user).full_name).to eq('John Doe')
  end

  it 'is not valid without email' do
    expect(build(:user, email: ' ')).not_to be_valid
  end

  it 'is not valid without first name' do
    expect(build(:user, first_name: ' ')).not_to be_valid
  end

  it 'is not valid with duplicate email' do
    create(:user)
    expect(build(:user, first_name: 'Jane', last_name: 'Doe')).not_to be_valid
  end
end
