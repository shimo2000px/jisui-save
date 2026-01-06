class RecipesController < ApplicationController
  def index
    @recipes = [
      # これは仮のものです
      { title: "ふんわり卵の節約親子丼", cost: 150, time: 15, image: "🥚" },
      { title: "豆苗と豚肉のシャキシャキ炒め", cost: 200, time: 10, image: "🌱" },
      { title: "大根たっぷり染み旨煮", cost: 100, time: 20, image: "🍲" }
    ]
  end

  def new
    @recipe = Recipe.new
    # 5つ分くらい最初から表示しておくと親切です
    5.times { @recipe.recipe_ingredients.build }
  end

def create
  @recipe = Recipe.new(recipe_params)
  @recipe.user_id = current_user.id
  
  if params[:recipe][:steps].is_a?(Array)
    @recipe.steps = params[:recipe][:steps].select(&:present?).join("\n")
  end

  if @recipe.save
    redirect_to @recipe, notice: "レシピを投稿しました！"
  else
    render :new
  end
end

private

  def recipe_params
    params.require(:recipe).permit(
      :title, :description, :convenience_food_id, :is_public,
      steps: [],
      recipe_ingredients_attributes: [:id, :ingredient_id, :amount_gram, :custom_price, :_destroy]
    )
  end
end
