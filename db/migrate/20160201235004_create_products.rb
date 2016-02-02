class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price
      t.boolean :published, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
