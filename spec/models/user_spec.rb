require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    it "すべての値が正しく入力されていれば保存できること" do
      expect(@user).to be_valid
    end
    it "ニックネームが空では登録できない" do
      @user.nickname = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "Nickname can't be blank" )
    end
    it "メールアドレスが空では登録できない" do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "Email can't be blank" )
    end
    it "メールアドレスに＠がないと登録できない" do
      @user.email = "qweasdzxc"     
      @user.valid?
      expect(@user.errors.full_messages).to include("Email is invalid")
    end
    it "パスワードが空では登録できない" do
      @user.password = ""
      @user.valid?
      expect(@user.errors.full_messages).to include( "Password can't be blank", "Password include both letters and numbers", "Password confirmation doesn't match Password" )
    end
    it "パスワードが半角英数字混合でないと登録できない" do
      @user.password = "１２３あああ"
      @user.password_confirmation = "１２３あああ"
      @user.valid?
      expect(@user.errors.full_messages).to include( "Password include both letters and numbers" )
    end
    it "パスワードが6文字以上でないと登録できない" do
      @user.password = "as12"
      @user.password_confirmation = "as12"
      @user.valid?
      expect(@user.errors.full_messages).to include( "Password is too short (minimum is 6 characters)" )
    end
    it "パスワード(確認)がパスワードと同じでないと登録できない" do
      @user.password_confirmation = Faker::Internet.password(min_length: 6)  
      @user.valid?
      expect(@user.errors.full_messages).to include( "Password confirmation doesn't match Password" )
    end
    it "名字が空では登録できない" do
      @user.last_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "Last name can't be blank", "Last name Full-width characters" )
    end
    it "名字が全角日本語でないと登録できない" do
      @user.last_name = "ﾀﾅｶ"
      @user.valid?
      expect(@user.errors.full_messages).to include( "Last name Full-width characters" )
    end
    it "名前が空では登録できない" do
      @user.first_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "First name can't be blank", "First name Full-width characters" )
    end
    it "名前が全角日本語でないと登録できない" do
      @user.first_name = "ﾀﾛｳ"
      @user.valid?
      expect(@user.errors.full_messages).to include( "First name Full-width characters" )
    end
    it "名字(カナ)が空では登録できない" do
      @user.last_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "Last name kana can't be blank", "Last name kana Full-width katakana characters" )
    end
    it "名字(カナ)が全角カタカナでないと登録できない" do
      @user.last_name_kana = "ﾀﾅｶ"
      @user.valid?
      expect(@user.errors.full_messages).to include( "Last name kana Full-width katakana characters" ) 
    end
    it "名前(カナ)が空では登録できない" do
      @user.first_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "First name kana can't be blank", "First name kana Full-width katakana characters" )
    end
    it "名前(カナ)が全角カタカナでないと登録できない" do
      @user.first_name_kana = "ﾀﾛｳ"
      @user.valid?
      expect(@user.errors.full_messages).to include( "First name kana Full-width katakana characters" ) 
    end
    it "生年月日が空では登録できない" do
      @user.birthday = nil
      @user.valid?
      expect(@user.errors.full_messages).to include( "Birthday can't be blank" )
    end
  end
end
