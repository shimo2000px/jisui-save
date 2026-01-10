class CreateCookingRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :cooking_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :cooking_cost
      t.integer :convenience_cost
      t.datetime :cooked_at

      t.timestamps
    end
  end
end
