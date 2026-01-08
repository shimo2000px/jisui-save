class RecipesController < ApplicationController
  def index
    base_query = Recipe.with_attached_image.includes(:convenience_food)

    if params[:filter] == "mine" && current_user
      @recipes = base_query.where(user_id: current_user.id)
                          .order(created_at: :desc)
      @current_filter = "mine"
    else
      # デフォルト：公開レシピのみ（みんなのレシピ）
      @recipes = base_query.where(is_public: true)
                          .order(created_at: :desc)
      @current_filter = "public"
    end
  end

  def new
    @recipe = Recipe.new
    # 5つ分くらい最初から表示しておくと親切です
    5.times { @recipe.recipe_ingredients.build }
  end

  def show
  @recipe = Recipe.find(params[:id])

    if !@recipe.is_public? && @recipe.user != current_user
      redirect_to recipes_path, alert: "このレシピは非公開です"
    end
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    if params[:recipe][:steps].is_a?(Array)
      @recipe.steps = params[:recipe][:steps].select(&:present?).join("\n")
    end

    if @recipe.save
      redirect_to recipes_path, notice: "レシピを投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    # 自分のレシピ以外は操作できないようにガード
    return redirect_to recipes_path unless @recipe.user == current_user

    @recipe.update(is_public: !@recipe.is_public)

    # Turboを使って一部分だけ書き換える（または一覧へ戻る）
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to recipes_path }
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
