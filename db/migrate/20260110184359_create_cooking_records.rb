class CreateCookingRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :cooking_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :cooking_cost, null: false
      t.integer :convenience_cost, null: false
      t.datetime :cooked_at, null: false, index: true

      t.timestamps
    end
  end
end
