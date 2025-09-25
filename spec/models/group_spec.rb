require 'rails_helper'

RSpec.describe 'Groupモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group.valid? }

    let(:user) { create(:user) }
    let!(:group) { build(:group, owner: user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        group.name = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '200文字以下であること: 200文字は〇' do
        group.introduction = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        group.introduction = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'ownerとN:1となっている' do
        expect(Group.reflect_on_association(:owner).macro).to eq :belongs_to
      end
      it 'membersとN:Nとなっている' do
        expect(Group.reflect_on_association(:members).macro).to eq :has_many
      end
    end
  end
end