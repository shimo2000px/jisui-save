load(Rails.root.join("db/seeds/ingredients.rb"))
load(Rails.root.join("db/seeds/convenience_foods.rb"))

# 後で削除予定
  user = User.find_by(email: "shimo2000px@gmail.com")
  if user
    user.update!(admin: true)
    puts "管理者権限を付与しました: #{user.email}"
  else
    puts "ユーザーが見つかりませんでした"
  end