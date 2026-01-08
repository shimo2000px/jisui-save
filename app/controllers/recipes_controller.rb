class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    base_query = Recipe.with_attached_image.includes(:convenience_food)

    if params[:filter] == "mine" && current_user
      @recipes = base_query.where(user_id: current_user.id)
                          .order(created_at: :desc)
                          .page(params[:page]).per(9)
      @current_filter = "mine"
    else
      @recipes = base_query.where(is_public: true)
                          .order(created_at: :desc)
                          .page(params[:page]).per(9)
      @current_filter = "public"
    end
  end

  def new
    @recipe = Recipe.new
    3.times { @recipe.recipe_ingredients.build }
  end

  def show
  @recipe = Recipe.find(params[:id])

    if !@recipe.is_public? && @recipe.user != current_user
      redirect_to recipes_path, alert: "このレシピは非公開です"
    end
  end

def create
  # 1. 保存用のパラメータを取得
  processed_params = recipe_params
  
  # 2. 配列で届いている steps を文字列に合体させて、上書きする
  if params[:recipe][:steps].is_a?(Array)
    processed_params[:steps] = params[:recipe][:steps].reject(&:blank?).join("\n")
  end

  # 3. 加工した processed_params を使って作成
  @recipe = Recipe.new(processed_params)
  @recipe.user_id = current_user.id

  if @recipe.save
    redirect_to recipes_path, notice: "レシピを投稿しました！"
  else
    @recipe.steps = @recipe.steps.to_s.split("\n")
    render :new, status: :unprocessable_entity
  end
end  

def edit
  end


def update
  processed_params = recipe_params
  
  if params[:recipe][:steps].is_a?(Array)
    processed_params[:steps] = params[:recipe][:steps].reject(&:blank?).join("\n")
  end

  # 3. 加工した processed_params を使って更新
  if @recipe.update(processed_params)
    redirect_to recipe_path(@recipe), notice: "レシピを更新しました！"
  else
    @recipe.steps = @recipe.steps.to_s.split("\n")
    render :edit, status: :unprocessable_entity
  end
end 

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "レシピを削除しました", status: :see_other
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    return redirect_to recipes_path unless @recipe.user == current_user

    @recipe.update(is_public: !@recipe.is_public)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to recipes_path }
    end
  end

  def copy
    original_recipe = Recipe.includes(:recipe_ingredients).find(params[:id])
    
    @recipe = Recipe.new(original_recipe.attributes.except("id", "created_at", "updated_at"))

    original_recipe.recipe_ingredients.each do |ri|
      attrs = ri.attributes.slice("ingredient_id", "amount_gram", "custom_price")
      @recipe.recipe_ingredients.build(attrs)
    end

    render :new
  end

private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def authorize_user!
    unless @recipe.user == current_user
      redirect_to recipes_path, alert: "権限がありません。"
    end
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :description, :convenience_food_id, :is_public, :image, 
      steps: [], # 配列として送られてくるので、一旦ここで配列として許可する
      recipe_ingredients_attributes: [ :id, :ingredient_id, :amount_gram, :custom_price, :_destroy ]
    )
  end
end

