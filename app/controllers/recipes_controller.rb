class RecipesController < ApplicationController
  def index
    @recipes = [
      #これは仮のものです
      { title: "ふんわり卵の節約親子丼", cost: 150, time: 15, image: "🥚" },
      { title: "豆苗と豚肉のシャキシャキ炒め", cost: 200, time: 10, image: "🌱" },
      { title: "大根たっぷり染み旨煮", cost: 100, time: 20, image: "🍲" }
    ]
  end
end
