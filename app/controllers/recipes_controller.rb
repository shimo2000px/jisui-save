class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :edit, :update, :destroy ]

  def index
    if params[:filter] == "mine" && guest_user?
        redirect_to recipes_path(filter: "public"), alert: "「MYレシピ」の利用にはアカウント登録が必要です"
        return
    end

    base_query = Recipe.with_attached_image.includes(:cooking_records, :convenience_food).all

    if params[:filter] == "mine" && current_user
      @recipes = base_query.where(user_id: current_user.id)
                          .order(created_at: :desc)
                          .page(params[:page]).per(12)
      @current_filter = "mine"
    else
      @recipes = base_query.where(is_public: true)
                          .order(created_at: :desc)
                          .page(params[:page]).per(12)
      @current_filter = "public"
    end
  end

  def create
    processed_params = recipe_params

    if params[:recipe][:steps].is_a?(Array)
      processed_params[:steps] = params[:recipe][:steps].reject(&:blank?).join("\n")
    end

    @recipe = Recipe.new(processed_params)
    @recipe.user_id = current_user.id

    if @recipe.save
      redirect_to recipes_path, notice: "レシピを投稿しました！"
    else
      @recipe.steps = @recipe.steps.to_s.split("\n")
      render :new, status: :unprocessable_entity
    end
  end


  def new
  if guest_user?
      redirect_to recipes_path, alert: "レシピを新しく作るにはアカウント登録が必要です"
      return
  end

    @recipe = Recipe.new
    3.times { @recipe.recipe_ingredients.build }
    @ingredients = Ingredient.all.order(:id)
  end

  def show
  @recipe = Recipe.find(params[:id])

    if !@recipe.is_public? && @recipe.user != current_user
      redirect_to recipes_path, alert: "このレシピは非公開です"
    end
  end

  def edit
  @ingredients = Ingredient.all.order(:id)
  end


def update
  processed_params = recipe_params

  if params[:recipe][:steps].is_a?(Array)
    processed_params[:steps] = params[:recipe][:steps].reject(&:blank?).join("\n")
  end

  if @recipe.update(processed_params)
    redirect_to recipe_path(@recipe), notice: "レシピを更新しました！"
  else
    @recipe.steps = @recipe.steps.to_s.split("\n")
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.user == current_user || current_user.admin?
      @recipe.destroy
      redirect_to recipes_path, notice: "レシピを削除しました。", status: :see_other
    else
      redirect_to recipes_path, alert: "権限がありません。", status: :see_other
    end
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    return redirect_to recipes_path unless @recipe.user == current_user

    new_status = params[:is_public].present? ? params[:is_public] == "true" : !@recipe.is_public
    @recipe.update(is_public: new_status)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: recipes_path) }
    end
  end

  def copy
    if guest_user?
        redirect_to recipe_path, alert: "自炊を記録するにはアカウント登録が必要です"
      return
    end

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

  def require_login_except_guest_view
  if guest_user?
    redirect_to login_path, alert: "レシピの作成や編集には、アカウント登録が必要です"
  elsif !logged_in?
    redirect_to login_path, alert: "ログインが必要です。"
  end
end

  def recipe_params
    params.require(:recipe).permit(
      :title, :description, :convenience_food_id, :is_public, :image,
      steps: [],
      recipe_ingredients_attributes: [ :id, :ingredient_id, :amount_gram, :custom_price, :_destroy ]
    )
  end
end
