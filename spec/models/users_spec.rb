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

  context 'when created' do
    subject(:user) { create(:user) }

    let(:default_role) { create(:role) }

    it { is_expected.to be_approved }
    it { is_expected.to have_attributes(balance: 100_000, roles: [default_role]) }

    it 'is not an admin' do
      create(:role, :admin)
      expect(user).not_to be_admin
    end
  end

  context 'when user is admin' do
    subject { create(:user, :admin) }

    let(:admin_role) { Role.find_by(name: 'admin') }

    it { is_expected.to be_admin }
    it { is_expected.to have_attributes(roles: [admin_role]) }
  end

  context 'when user upgrades account' do
    subject(:user) { create(:user) }

    let(:buyer_role) { create(:role) }
    let(:broker_role) { create(:role, :broker) }

    before do
      create(:role, :broker)
      user.upgrade_account
    end

    it { is_expected.to have_attributes(roles: [buyer_role, broker_role]) }
    it { is_expected.to be_pending }

    it 'has multiple roles' do
      expect(user.roles.count).to be > 1
    end
  end
end
