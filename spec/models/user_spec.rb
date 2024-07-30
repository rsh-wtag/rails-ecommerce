require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('userexample.com').for(:email) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(6).on(:create) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(admin: 0, user: 1) }
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
      user = create(:user, phone: '01712345678')
      expect(user.phone).to eq('+8801712345678')
    end
  end
end
