require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end


RSpec.describe 'Items', type: :request do

  include AuthRequestHelper
  before do  
    @item = FactoryBot.create(:item)
  end
  
  describe "GET #index" do
    it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
      basic_pass root_path
      expect(response.status).to eq 200
    end
    it "indexアクションにリクエストするとレスポンスに出品済みの商品名が存在する" do
      basic_pass root_path
      expect(response.body).to include @item.name
    end
    it "indexアクションにリクエストするとレスポンスに出品済みの商品の画像URLが存在する" do
      basic_pass root_path
      expect(response.body).to include @item.image
    end
    it "indexアクションにリクエストするとレスポンスに検索フォームが存在する" do
     basic_pass root_path
     expect(response.body).to include "キーワードから探す"
    end  
  end

  describe "GET #show" do
    it "showアクションにリクエストすると正常にレスポンスが返ってくる" do
      basic_pass root_path
      get item_path(@item)
      expect(response.status).to eq 200
    end
    it "showアクションにリクエストするとレスポンスに出品済みの商品名が存在する" do
      basic_pass root_path
      get item_path(@item)
      expect(response.body).to include @item.name
    end
    it "showアクションにリクエストするとレスポンスに出品済みの画像URLが存在する" do
      basic_pass root_path
      get item_path(@item)
      expect(response.body).to include @item.image
    end
    it "showアクションにリクエストするとレスポンスにコメントのフォームが存在する" do
      basic_pass root_path
      get item_path(@item)
      expect(response.body).to include "コメントする" 
    end
  end
  
  
end
