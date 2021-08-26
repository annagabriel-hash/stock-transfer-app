require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe 'welcome email' do
    let(:mail) { described_class.with(id: user.id).welcome_email }

    it 'renders welcome headers' do
      expect(mail.subject).to eq('Welcome to the Stock App')
    end

    it 'sets user email as the receipient' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders body' do
      expect(mail.body.encoded).to match('Welcome')
    end
  end
end
