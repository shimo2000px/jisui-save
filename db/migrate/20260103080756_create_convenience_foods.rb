class CreateConvenienceFoods < ActiveRecord::Migration[7.2]
  def change
    create_table :convenience_foods do |t|
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
