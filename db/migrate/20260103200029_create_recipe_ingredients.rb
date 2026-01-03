class CreateRecipeIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :amount_gram
      t.integer :custom_price

      t.timestamps
    end
  end
end
