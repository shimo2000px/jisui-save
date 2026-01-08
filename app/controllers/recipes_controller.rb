class RecipesController < ApplicationController
  def index
  @recipes = Recipe.with_attached_image.includes(:convenience_food).order(created_at: :desc)
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
    render :new, status: :unprocessable_entity
  end
end

private

  def recipe_params
    params.require(:recipe).permit(
      :title, :description, :convenience_food_id, :is_public, :image, steps: [],
      recipe_ingredients_attributes: [ :id, :ingredient_id, :amount_gram, :custom_price, :_destroy ]
    )
  end
end
