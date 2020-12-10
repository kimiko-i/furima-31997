require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '商品を購入する', type: :system do
  before do
    @purchase_form = FactoryBot.build(:purchase_form)
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '商品が購入できるとき' do
    it 'ログインしたユーザーは商品を購入できる' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品2の詳細ページへ遷移する
      click_link href: item_path(@item2), match: :first
      # 商品2の詳細ページに購入ボタンがあることを確認する
      has_link?('購入画面に進む')
      # 購入ページヘ遷移する
      click_on('購入画面に進む')
      # 購入情報を入力する
      fill_in 'postal-code', with: @purchase_form.postal_code
      select Prefecture.data[@purchase_form.prefecture_id - 1][:name], from: "prefecture"
      fill_in 'city', with: @purchase_form.city
      fill_in 'addresses', with: @purchase_form.house_number
      fill_in 'building', with: @purchase_form.building_name
      fill_in 'phone-number', with: @purchase_form.tel
      @purchase_form.user_id = @item1.user_id
      @purchase_form.item_id = @item1.id
      # 購入ボタンを押すとorderモデルのカウントが１上がることを確認する
      find('input[name="commit"]').click
      token = @purchase_form.token
      change { Order.count }.by(1)
      # トップページへ遷移する
      visit root_path
      # 先程購入した商品2の詳細ページへ遷移する
      click_link href: item_path(@item2), match: :first
      # 先程購入した商品にSold Outが表示されていることを確認する
      has_text?('Sold Out!!')
      # 商品2の詳細ページに購入ボタンがないことを確認する
      has_no_link?('購入画面に進む')
    end
  end

  context '商品が購入できないとき' do
    it 'ログインしたユーザーは自分が出品した商品の購入画面には遷移できない' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品1の詳細ページへ遷移する
      click_link href: item_path(@item1), match: :first
      # 商品1の詳細ページに購入ボタンがないことを確認する
      has_no_link?('購入画面に進む')
    end
    it 'ログインしていないユーザーは商品の購入画面に遷移できない' do
      # トップページにいる
      basic_pass root_path
      visit root_path
      # 商品1の詳細ページへ遷移する
      click_link href: item_path(@item1), match: :first
      # 商品1の詳細ページに購入ボタンがないことを確認する
      has_no_link?('購入画面に進む')
      visit root_path
      # 商品2の詳細ページへ遷移する
      click_link href: item_path(@item2), match: :first
      # 商品2の詳細ページに購入ボタンがないことを確認する
      has_no_link?('購入画面に進む')
    end
  end
end
