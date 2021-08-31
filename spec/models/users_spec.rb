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

  it { is_expected.to respond_to(:upgrade_account) }

  it 'can be assigned with multiple roles' do
    user = create(:user)
    roles_list = [create(:role), create(:role, :broker)]
    user.roles = roles_list
    user.save!
    expect(user.reload.roles).to match_array(roles_list)
  end

  context 'when created' do
    let!(:user) { create(:user) }

    it 'has a buyer role' do
      default_role = Role.find_by(name: 'buyer')
      expect(user.roles).to match_array([default_role])
    end

    it 'has an approved status' do
      expect(user.status).to eq('approved')
    end

    it 'has an inital balance' do
      expect(user.balance).to eq(100_000)
    end
  end

  context 'when created with role' do
    it 'assigns the specified role' do
      user = create(:user, :admin)
      admin_role = Role.find_by(name: 'admin')
      expect(user.roles).to match_array([admin_role])
    end
  end

  context 'when added with broker role' do
    it 'changes user status to pending' do
      user = create(:user)
      broker = create(:role, :broker)
      expect { user.roles << broker }.to change { user.status }.to('pending')
    end
  end

  context 'when user is admin'
  it 'admin attribute returns true' do
    admin_user = create(:user, :admin)
    expect(admin_user.admin?).to be true
  end

  context 'when user is not an admin'
  it 'admin attribute returns false' do
    create(:role, :admin)
    buyer_user = create(:user)
    expect(buyer_user.admin?).to be false
  end

  context 'when user upgrades account' do
    let(:buyer_user) { create(:user) }
    let!(:broker_role) { create(:role, :broker) }

    it 'adds broker role' do
      buyer_user.upgrade_account
      expect(buyer_user.roles).to include broker_role
    end

    it 'changes user status to pending' do
      expect { buyer_user.upgrade_account }.to change(buyer_user, :status).from('approved').to('pending')
    end
  end
end
