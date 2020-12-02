require 'rails_helper'

RSpec.describe PurchaseForm, type: :model do
  before do
    @purchase_form = FactoryBot.build(:purchase_form)
  end

  describe '購入情報の保存' do
    context '購入情報が保存できる場合' do
      it 'すべての値が正しく入力されていれば保存できる' do
        expect(@purchase_form).to be_valid
      end
    end

    context '購入情報が保存できない場合' do
      it 'tokenが空では登録できないこと' do
        @purchase_form.token = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Token can't be blank")
      end
      it '郵便番号が空だと保存できないこと' do
        @purchase_form.postal_code = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Postal code can't be blank", 'Postal code Include hyphen(-)')
      end
      it '郵便番号が半角のハイフンを含んだ正しい形式でないと保存できないこと' do
        @purchase_form.postal_code = 1_234_567
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Postal code Include hyphen(-)')
      end
      it '都道府県を選択していないと保存できないこと' do
        @purchase_form.prefecture_id = 1
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Prefecture Select')
      end
      it '都道府県が空では保存できないこと' do
        @purchase_form.prefecture_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Prefecture Select')
      end
      it '地区町村が空だと保存できないこと' do
        @purchase_form.city = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("City can't be blank")
      end
      it '番地が空だと保存できないこと' do
        @purchase_form.house_number = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("House number can't be blank")
      end
      it '建物名は空でも保存できること' do
        @purchase_form.building_name = nil
        expect(@purchase_form).to be_valid
      end
      it '電話番号が空だと保存できないこと' do
        @purchase_form.tel = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Tel can't be blank")
      end
      it '電話番号が半角数字のハイフンを含まない形式出ないと保存できないこと' do
        @purchase_form.tel = '090-1234-5678'
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Tel Input only number')
      end
      it 'user_idがないと保存できないこと' do
        @purchase_form.user_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("User can't be blank")
      end
      it 'item_idがないと保存できないこと' do
        @purchase_form.item_id = nil
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
