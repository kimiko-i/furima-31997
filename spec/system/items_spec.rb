require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "商品を出品する", type: :system do

  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context '商品が出品できるとき' do
    it 'ログインしたユーザーは商品を出品できる' do
      # ログインする
      basic_pass root_path
      sign_in(@user)
      # 出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ページへ移動する
      click_on('出品する')
      # フォームに情報を入力する
      image_path = Rails.root.join('public/images/test_image.png')
      attach_file('item[image]', image_path, make_visible: true)
      fill_in 'item-name', with: @item.name
      fill_in 'item-info', with: @item.detail
      select Category.data[@item.category_id - 1][:name], from: "item-category"
      select Status.data[@item.status_id - 1][:name], from: "item-sales-status"
      select Shipping.data[@item.shipping_id - 1][:name], from: "item-shipping-fee-status"
      select SendFrom.data[@item.send_from_id - 1][:name], from: "item-prefecture"
      select ShipmentDay.data[@item.shipment_day_id][:name], from: "item-scheduled-delivery"
      fill_in 'item-price', with: @item.price
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{find('input[name="commit"]').click}.to change { Item.count }.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページに先程出品した商品の画像が存在することを確認する
      expect(page).to have_selector ".item-img[src$='test_image.png']"
      # トップページに先程出品した商品の商品名が存在することを確認する
      expect(page).to have_content(@item.name)
    end
  end

  context '商品が出品できないとき' do
    it 'ログインしていないと出品ページに遷移できない' do
      # トップページに遷移する
      basic_pass root_path
      visit root_path
      # 出品ページのリンクを押してもログインページに遷移する
      find_link("出品する", href:"/items/new").click
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe '出品商品の編集', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '出品した商品が編集できるとき' do
    it 'ログインしたユーザーは自分が出品した商品を編集することができる' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品1の詳細ページへ遷移する
      click_link href: item_path(@item1), match: :first
      # 商品1の詳細ページに編集ボタンがあることを確認する
      has_link?('商品の編集')
      # 編集ページヘ遷移する
      click_on ('商品の編集')
      # すでに出品情報がフォームに入っていることを確認する
      expect(find_field('item[name]').text).to eq @item1.name
      expect(find_field('item[detail]').text).to eq @item1.detail
      expect(page).to have_select('item[category_id]', selected: Category.data[@item1.category_id - 1][:name])
      expect(page).to have_select('item[status_id]', selected: Status.data[@item1.status_id - 1][:name])
      expect(page).to have_select('item[shipping_id]', selected: Shipping.data[@item1.shipping_id - 1][:name])
      expect(page).to have_select('item[send_from_id]', selected: SendFrom.data[@item1.send_from_id - 1][:name])
      expect(page).to have_select('item[shipment_day_id]', selected: ShipmentDay.data[@item1.shipment_day_id - 1][:name])
      # 出品内容を編集する
      fill_in 'item-name', with: "#{ @item1.name }+ 編集した商品名"
      fill_in 'item-info', with: "#{ @item1.detail }+編集した商品の説明"
      select Category.data[@item1.category_id - 1][:name], from: "item-category"
      select Status.data[@item1.status_id - 1][:name], from: "item-sales-status"
      select Shipping.data[@item1.shipping_id - 1][:name], from: "item-shipping-fee-status"
      select SendFrom.data[@item1.send_from_id - 1][:name], from: "item-prefecture"
      select ShipmentDay.data[@item1.shipment_day_id - 1][:name], from: "item-scheduled-delivery"
      fill_in 'item-price', with: @item1.price = Faker::Number.within(range: 300..9_999_999)
      # 編集してもItemモデルのカウントは変わらないことを確認する
      expect{find('input[name="commit"]').click}.to change { Item.count }.by(0)
      # 商品詳細ページに遷移する
      expect(current_path).to eq item_path(@item1)
      # 変更した内容の商品画像が存在することを確認する
      # expect(page).to have_selector ".item-img[src=#{@item1.image} + 編集したURL]"
      # 変更した内容の商品名が存在することを確認する
      expect(page).to have_content( @item1.name )
      # 変更した内容の価格が存在することを確認する
      expect(page).to have_content( @item1.price )
      # トップページに先程変更した内容の配送料の負担が存在することを確認する
      expect(page).to have_text(Shipping.data[@item1.shipping_id - 1][:name])
    end
  end

  context '商品が編集できないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の編集画面には遷移できない' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品2の詳細ページに移る
      click_link href: item_path(@item2), match: :first
      # 商品2の詳細ページに商品の編集ボタンがないことを確認する
      has_no_link?('商品の編集')
    end
    it 'ログインしていないとツイートの編集画面には遷移できない' do
      # トップページにいる
      basic_pass root_path
      visit root_path
      # 商品1の詳細ページに移る
      click_link href: item_path(@item1), match: :first
      # 商品1に編集ボタンがないことを確認する
      has_no_link?('商品の編集')
      visit root_path
      # 商品2の詳細ページに移る
      click_link href: item_path(@item2), match: :first
      # 商品2に編集ボタンがないことを確認する
      has_no_link?('商品の編集')
    end
  end
end

RSpec.describe '商品の削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context '出品した商品が削除できるとき' do
    it 'ログインしたユーザーは自らが投稿した商品の削除ができる' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品1の詳細ページに移る
      click_link href: item_path(@item1), match: :first
      # 商品1に削除ボタンがあることを確認する
      has_link?('削除')
      # 商品を削除するとレコードの数が1減ることを確認する
      click_on('削除')
      change { Item.count }.by(-1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには商品1の情報が存在しないことを確認する(画像)
      expect(page).to have_no_selector(".item-img[src = '@item1.image']")
      # トップページには商品1の情報が存在しないことを確認する(商品名)
      expect(page).to have_no_content( @item1.name)
      # トップページには商品1の情報が存在しないことを確認する(価格)
      expect(page).to have_no_content( @item1.price)
      # トップページには商品1の情報が存在しないことを確認する(配送料の負担)
      expect(page).to have_no_content( 'Shipping.data[@item1.shipping_id - 1][:name]')
    end
  end

  context '商品が削除できないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の削除ができない' do
      # 商品1を出品したユーザーでログインする
      basic_pass root_path
      sign_in(@item1.user)
      # 商品1の詳細ページに移る
      click_link href: item_path(@item1), match: :first
      # 商品1に削除ボタンがないことを確認する
      has_no_link?('削除')
      visit root_path
      # 商品2の詳細ページに移る
      click_link href: item_path(@item2), match: :first
      # 商品2に削除ボタンがないことを確認する
      has_no_link?('削除')
    end
    it 'ログインしていないと商品の削除ボタンがない' do
      # トップページに移動する
      basic_pass root_path
      visit root_path
      # 商品1の詳細ページに移る
      click_link href: item_path(@item1), match: :first
      # 商品1に削除ボタンがないことを確認する
      has_no_link?('削除')
      visit root_path
      # 商品2の詳細ページに移る
      click_link href: item_path(@item2), match: :first
      # 商品2に削除ボタンがないことを確認する
      has_no_link?('削除')
    end
  end
end

RSpec.describe '商品の詳細', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  it 'ログインしたユーザーは商品詳細ページに遷移すると購入ボタンが表示される' do
    # 商品1を出品したユーザーでログインする
    basic_pass root_path
    sign_in(@item1.user)
    # 商品2の詳細ページに移る
    click_link href: item_path(@item2), match: :first
    # 購入画面に進むボタンが存在する
    has_link?('購入画面に進む')
    visit root_path
    # 商品1の詳細ページに移る
    click_link href: item_path(@item1), match: :first
    # 購入画面に進むボタンが存在しない
    has_no_link?('購入画面に進む')
  end
  it 'ログインしていないユーザーは購入画面に進むボタンが表示されない' do
    # トップページに移動する
    basic_pass root_path
    visit root_path
    # 商品1の詳細ページに移る
    click_link href: item_path(@item1), match: :first
    # 購入画面に進むボタンが存在しない
    has_no_link?('購入画面に進む')
    visit root_path
    # 商品2の詳細ページに移る
    click_link href: item_path(@item2), match: :first
    # 購入画面に進むボタンが存在しない
    has_no_link?('購入画面に進む')
  end
end
