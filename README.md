# テーブル設計

## users テーブル

| Column          | Type               | Options     |
|:---------------:|:------------------:|:-----------:|
| first_name      | string             | null: false |
| last_name       | string             | null: false |
| first_name_kana | string             | null: false |
| last_name_kana  | string             | null: false |
| nickname        | string             | null: false |
| email           | string             | null: false |
| password        | encrypted_password | null: false |
| birthday        | date               | null: false |

### Association

- has_many :items
- has_many :purchases

## items テーブル

| Column         | Type       | Options           |
|:--------------:|:----------:|:-----------------:|
| item_name      | string     | null: false       |
| price          | string     | null: false       |
| user           | references | foreign_key: true |
| category       | integer    | null: false       |
| status         | integer    | null: false       |
| shipping       | integer    | null: false       |
| shipment_day   | integer    | null: false       |

### Association

- belongs_to :user
- has_one :purchase

## profiles テーブル

| Column        | Type       | Option            |
|:-------------:|:----------:|:-----------------:|
| postal_code   | string     | null: false       |
| prefecture    | integer    | null: false       |
| city          | string     | null: false       |
| house_number  | integer    | null: false       |
| building_name | string     |                   |
| tel           | string     | null: false       |
| user          | references | foreign_key: true |

### Association

- belongs_to :purchase

## purchase テーブル

| Column       | Type       | Options           |
|:------------:|:----------:|:-----------------:|
| user         | references | foreign_key: true |
| items        | references | foreign_key: true |
| purchased_at | date       | null: false       |

### Association

- belongs_to :user
- belongs_to :item
- has_one :profile