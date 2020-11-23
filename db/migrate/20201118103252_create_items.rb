class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string      :name,                     null: false
      t.integer     :price,                    null: false
      t.text        :detail,                   null: false
      t.references  :user,                     null: false,  foreign_key: true 
      t.integer     :category_id,              null: false
      t.integer     :status_id,                null: false
      t.integer     :shipping_id,              null: false
      t.integer     :shipment_day_id,          null: false
      t.integer     :send_from_id,             null: false 
      t.timestamps
    end
  end
end
