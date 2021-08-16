require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { described_class.new(first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com', password_confirmation: 'password') }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end
end
