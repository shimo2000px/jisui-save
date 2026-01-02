class CreateIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.decimal :price_per_gram, precision: 10, scale: 2

      t.timestamps
    end
  end
end
