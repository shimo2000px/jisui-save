class CreateGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.date :target_month, null: false
      t.integer :target_amount
      t.integer :target_times
      t.datetime :achieved_at

      t.timestamps
    end
    add_index :goals, [:user_id, :target_month], unique: true
  end
end
