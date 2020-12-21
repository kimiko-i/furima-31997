# フリーマーケットアプリケーション

## アプリケーションの概要

- 商品の出品・購入ができるフリーマーケットアプリケーションです。

## [URL](http://18.181.24.194)

## テストアカウント

- 購入者用
  - メールアドレス: qqqq@qqqq
  - パスワード: qqq111
  - 購入用カード情報
    - 番号：4242424242424242
    - 期限：Mon Mar 23 2020 00:00:00 GMT+0900 (日本標準時)
    - セキュリティコード：123

- 出品者用
  - メールアドレス名: qweasd@qweasd
  - パスワード: qwe123

## 利用方法

- ユーザー登録
  - 新規登録画面からユーザー登録が行えます。
- 商品出品機能
  - ユーザー登録後、商品の出品・編集・削除が行えます。
- 商品購入機能
  - 購入したい商品を選択後、購入画面から購入手続きが行えます。

## テーブル設計
### users テーブル

| Column            | Type     | Options     |
|:-----------------:|:--------:|:-----------:|
| first_name        | string   | null: false |
| last_name         | string   | null: false |
| first_name_kana   | string   | null: false |
| last_name_kana    | string   | null: false |
| nickname          | string   | null: false |
| email             | string   | null: false |
| encrypted_password| string   | null: false |
| birthday          | date     | null: false |

#### Association

- has_many :items
- has_many :address
- has_one  :order

### items テーブル

| Column         | Type       | Options           |
|:--------------:|:----------:|:-----------------:|
| name           | string     | null: false       |
| price          | integer    | null: false       |
| detail         | text       | null: false       |
| user           | references | foreign_key: true |
| category_id    | integer    | null: false       |
| status_id      | integer    | null: false       |
| shipping_id    | integer    | null: false       |
| shipment_day_id| integer    | null: false       |
| send_from_id   | integer    | null: false

#### Association

- belongs_to :user
- has_one :order

### address テーブル

| Column        | Type       | Option            |
|:-------------:|:----------:|:-----------------:|
| postal_code   | string     | null: false       |
| prefecture_id | integer    | null: false       |
| city          | string     | null: false       |
| house_number  | string     | null: false       |
| building_name | string     |                   |
| tel           | string     | null: false       |
| order         | references | foreign_key: true |

#### Association

- belongs_to :order

### order テーブル

| Column       | Type       | Options           |
|:------------:|:----------:|:-----------------:|
| user         | references | foreign_key: true |
| item         | references | foreign_key: true |

#### Association

- belongs_to :user
- belongs_to :item
- has_one :address
