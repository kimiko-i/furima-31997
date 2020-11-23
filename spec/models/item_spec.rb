require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品の保存' do
    context '出品した商品が保存できる場合' do
      it 'すべてが入力されていれば保存できる' do
        expect(@item).to be_valid
      end
    end
    context '出品した商品が保存できない場合' do
      it '商品名がないと保存できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Name can't be blank")
      end
      it '商品画像がないと保存できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
      it '商品の説明がないと保存できない' do
        @item.detail = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Detail can't be blank")
      end
      it '価格がないと保存できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank", 'Price Half-width number', 'Price Out of setting range')
      end
      it '価格が全角数字では保存できない' do
        @item.price = '３４５'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price Half-width number', 'Price Out of setting range')
      end
      it '価格が¥300~¥9,999,999の間出ないと保存できない' do
        @item.price = 100
        @item.valid?
        expect(@item.errors.full_messages).to include('Price Out of setting range')
      end
      it '価格が¥10,000,000以上では保存できない' do
        @item.price = 10000000
        @item.valid?
        expect(@item.errors.full_messages).to include('Price Out of setting range')
      end
      it 'カテゴリーが選択されていないと保存できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Category Select')
      end
      it 'カテゴリーが空では保存できない' do
        @item.category_id = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Category Select')
      end
      it '商品の状態が選択されていないと保存できない' do
        @item.status_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Status Select')
      end
      it '商品の状態が空では保存できない' do
        @item.status_id = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Status Select')
      end
      it '配送料の負担が選択されていないと保存できない' do
        @item.shipping_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping fee status Select')
      end
      it '配送料の負担が空では保存できない' do
        @item.shipping_id = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping fee status Select')
      end
      it '配送元の地域が選択されていないと保存できない' do
        @item.send_from_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Send from prefecture Select')
      end
      it '配送元の地域が空では保存できない' do
        @item.send_from_id = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Send from prefecture Select')
      end
      it '発送までの日数が選択されていないと保存できない' do
        @item.shipment_day_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipment day Select')
      end
      it '発送までの日数が空では保存できない' do
        @item.shipment_day_id = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipment day Select')
      end
    end
  end
end
