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

  it 'can be assigned with multiple roles' do
    user = create(:user)
    roles_list = [create(:role), create(:role, :broker)]
    user.roles = roles_list
    user.save!
    expect(user.reload.roles).to match_array(roles_list)
  end

  context 'when created has no role' do
    it 'has a buyer role' do
      user = create(:user)
      default_role = Role.find_by(name: 'buyer')
      expect(user.roles).to match_array([default_role])
    end
  end
end
