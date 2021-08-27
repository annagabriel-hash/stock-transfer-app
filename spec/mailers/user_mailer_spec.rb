require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe 'welcome email' do
    let(:mail) { described_class.welcome_email(user) }

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

  describe 'verify email' do
    let(:mail) { described_class.verify_email(user) }

    it 'renders welcome headers' do
      expect(mail.subject).to eq('Stock App - Verify account')
    end

    it 'sets user email as the receipient' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders body' do
      expect(mail.body.encoded).to match('verify your account')
    end

    it 'contains confirm email link' do
      expect(mail.body.encoded).to have_link('Verify account', href: user_confirm_url(user))
    end
  end
end
