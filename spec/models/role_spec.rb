require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:role)).to be_valid
  end
end
