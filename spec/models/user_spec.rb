require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a valid phone number' do
      subject.phone = nil
      expect(subject).not_to be_valid
    end

    it 'is valid with a valid phone number' do
      subject.phone = '+8801712345678'
      expect(subject).to be_valid
    end
  end

  describe 'callbacks' do
    it 'normalizes the phone number before saving' do
      user = build(:user)
      expect(user).to receive(:normalize_phone_number)
      user.save
    end
  end

  describe 'methods' do
    it 'normalizes the phone number correctly' do
      user = create(:user, phone: '+8801712345678')
      expect(user.phone).to eq(PhonyRails.normalize_number('+8801712345678', default_country_code: 'BD'))
    end
  end
end
