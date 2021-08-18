require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:role)).to be_valid
  end

  it 'is not valid without name' do
    expect(build(:role, name: '  ')).not_to be_valid
  end

  it 'has unique names' do
    create(:role)
    duplicate_role = build(:role, name: 'BUYeR')
    expect(duplicate_role).not_to be_valid
  end

  it 'has names in lowercase' do
    name = 'ADMIN'
    expect(create(:role, name: name).name).to eq(name.downcase)
  end
end
