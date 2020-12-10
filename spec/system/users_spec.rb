require 'rails_helper'
require 'date'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      basic_pass root_path
      # トップページにサインアップへ遷移するボタンがあることを確認する
      has_link?('新規登録')
      # 新規登録ページへ移動する
      click_on '新規登録'
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name_kana]', with: @user.last_name_kana
      fill_in 'user[first_name_kana]', with: @user.first_name_kana
      select @user.birthday.year, from: "user_birthday_1i"
      select @user.birthday.month, from: "user_birthday_2i"
      select @user.birthday.day, from: "user_birthday_3i"
      # 新規登録ボタンを押すとユーザーモデルのカウントが１上がることを確認する
      expect{find('input[name="commit"]').click}.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ログイン状態のトップページにはログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      basic_pass root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      has_link?('新規登録')
      # 新規登録ページへ移動する
      click_on '新規登録'
      # ユーザー情報を入力する
      fill_in 'nickname', with: ""
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      fill_in 'password-confirmation', with: ""
      fill_in 'last-name', with: ""
      fill_in 'first-name', with: ""
      fill_in 'last-name-kana', with: ""
      fill_in 'first-name-kana', with: ""
      select "--", from: "user_birthday_1i"
      select "--", from: "user_birthday_2i"
      select "--", from: "user_birthday_3i"
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{find('input[name="commit"]').click}.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      basic_pass root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      has_link?('ログイン')
      # ログインページへ遷移する
      click_on 'ログイン'
      # 正しい情報を入力する
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ログイン状態のトップページにはログアウトボタンが表示されることを確認する
      has_link?('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      basic_pass root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      has_link?('ログイン')
      # ログインページへ遷移する
      click_on 'ログイン'
      # ユーザー情報を入力する
      fill_in 'email', with: ""
      fill_in 'password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end
