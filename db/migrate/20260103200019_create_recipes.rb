class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :convenience_food, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :steps
      t.boolean :is_public

      t.timestamps
    end
  end
end
