require 'rails_helper'

RSpec.describe 'GroupsControllerのテスト', type: :request do
  before do
    @user = create(:user)
    sign_in @user
  end

  describe 'POST #create' do
    let(:group_params) { { name: 'Test Group', introduction: 'Test introduction' } }

    context 'グループ作成成功のテスト' do
      it 'グループが正しく保存される' do
        expect {
          post groups_path, params: { group: group_params }
        }.to change(Group, :count).by(1)
      end

      it 'グループオーナーが自動的にメンバーに含まれる' do
        post groups_path, params: { group: group_params }
        created_group = Group.last
        expect(created_group.members).to include(@user)
      end

      it 'グループオーナーが正しく設定される' do
        post groups_path, params: { group: group_params }
        created_group = Group.last
        expect(created_group.owner).to eq(@user)
      end

      it '作成後にグループ詳細ページにリダイレクトされる' do
        post groups_path, params: { group: group_params }
        created_group = Group.last
        expect(response).to redirect_to(group_path(created_group))
      end
    end

    context 'グループ作成失敗のテスト' do
      it 'nameが空の場合、グループが保存されない' do
        invalid_params = { name: '', introduction: 'Test introduction' }
        expect {
          post groups_path, params: { group: invalid_params }
        }.to_not change(Group, :count)
      end
    end
  end
end