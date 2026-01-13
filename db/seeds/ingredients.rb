puts "Deleting existing ingredients..."
RecipeIngredient.delete_all
Ingredient.delete_all

ingredient_groups = {
  "🥩 肉類" => [
    { name: "鶏むね肉", price_per_gram: 0.90 },
    { name: "鶏もも肉", price_per_gram: 1.35 },
    { name: "鶏ささみ", price_per_gram: 1.10 },
    { name: "豚こま切れ肉", price_per_gram: 1.28 },
    { name: "豚バラ肉", price_per_gram: 1.98 },
    { name: "豚ロース肉", price_per_gram: 1.78 },
    { name: "合い挽き肉", price_per_gram: 1.18 },
    { name: "牛バラ肉", price_per_gram: 2.50 },
    { name: "牛もも肉(ブロック)", price_per_gram: 3.80 },
    { name: "牛すじ肉", price_per_gram: 1.60 },
    { name: "豚ヒレ肉", price_per_gram: 2.20 },
    { name: "ウインナー", price_per_gram: 1.50 },
    { name: "厚切りベーコン", price_per_gram: 1.90 },
    { name: "ロースハム", price_per_gram: 2.30 }
  ],
  "🥬 野菜" => [
    { name: "玉ねぎ", price_per_gram: 0.35 },
    { name: "にんじん", price_per_gram: 0.40 },
    { name: "じゃがいも", price_per_gram: 0.45 },
    { name: "キャベツ", price_per_gram: 0.20 },
    { name: "白菜", price_per_gram: 0.15 },
    { name: "大根", price_per_gram: 0.18 },
    { name: "もやし", price_per_gram: 0.15 },
    { name: "ブロッコリー", price_per_gram: 0.80 },
    { name: "ピーマン", price_per_gram: 0.65 },
    { name: "長ねぎ", price_per_gram: 0.55 },
    { name: "ほうれん草", price_per_gram: 0.75 },
    { name: "なす", price_per_gram: 0.65 },
    { name: "トマト", price_per_gram: 0.70 },
    { name: "きゅうり", price_per_gram: 0.60 },
    { name: "レタス", price_per_gram: 0.45 },
    { name: "にんにく", price_per_gram: 1.65 },
    { name: "小松菜", price_per_gram: 0.50 },
    { name: "ニラ", price_per_gram: 0.80 },
    { name: "パプリカ", price_per_gram: 1.20 },
    { name: "ズッキーニ", price_per_gram: 0.90 },
    { name: "アスパラガス", price_per_gram: 2.10 },
    { name: "水菜", price_per_gram: 0.55 },
    { name: "かぼちゃ", price_per_gram: 0.40 },
    { name: "生姜", price_per_gram: 1.20 },
    { name: "しいたけ", price_per_gram: 1.80 },
    { name: "しめじ", price_per_gram: 0.95 },
    { name: "えのき", price_per_gram: 0.45 },
    { name: "まいたけ", price_per_gram: 1.10 },
    { name: "エリンギ", price_per_gram: 0.85 }
  ],
  "🐟 魚介類" => [
    { name: "鮭の切り身", price_per_gram: 2.50 },
    { name: "塩サバ", price_per_gram: 1.80 },
    { name: "マグロ(赤身)", price_per_gram: 5.50 },
    { name: "しらす干し", price_per_gram: 3.50 },
    { name: "むきえび", price_per_gram: 2.60 },
    { name: "ツナ缶", price_per_gram: 2.10 },
    { name: "ちくわ", price_per_gram: 0.85 },
    { name: "明太子", price_per_gram: 3.80 },
    { name: "たらこ", price_per_gram: 3.50 }
  ],
  "🥚 卵・乳製品・豆腐" => [
    { name: "卵", price_per_gram: 0.45 },
    { name: "牛乳", price_per_gram: 0.25 },
    { name: "生クリーム", price_per_gram: 1.80 },
    { name: "ヨーグルト", price_per_gram: 0.45 },
    { name: "バター", price_per_gram: 2.20 },
    { name: "マーガリン", price_per_gram: 0.80 },
    { name: "ピザ用チーズ", price_per_gram: 1.65 },
    { name: "粉チーズ", price_per_gram: 4.50 },
    { name: "納豆", price_per_gram: 0.70 },
    { name: "豆腐", price_per_gram: 0.25 },
    { name: "厚揚げ", price_per_gram: 0.65 },
    { name: "油揚げ", price_per_gram: 1.10 },
    { name: "こんにゃく", price_per_gram: 0.35 }
  ],
  "🍚 炭水化物（米・麺・パン）" => [
    { name: "白米", price_per_gram: 0.70 },
    { name: "パスタ", price_per_gram: 0.30 },
    { name: "うどん", price_per_gram: 0.30 },
    { name: "焼きそば麺", price_per_gram: 0.45 },
    { name: "食パン", price_per_gram: 0.50 },
    { name: "薄力粉", price_per_gram: 0.25 },
    { name: "強力粉", price_per_gram: 0.35 },
    { name: "ホットケーキミックス", price_per_gram: 0.58 }

  ],
  "🧂 調味料・トッピング" => [
    { name: "醤油", price_per_gram: 0.40 },
    { name: "味噌", price_per_gram: 0.60 },
    { name: "砂糖", price_per_gram: 0.25 },
    { name: "塩", price_per_gram: 0.15 },
    { name: "サラダ油", price_per_gram: 0.50 },
    { name: "片栗粉", price_per_gram: 0.65 },
    { name: "パン粉", price_per_gram: 1.10 },
    { name: "マヨネーズ", price_per_gram: 0.85 },
    { name: "ケチャップ", price_per_gram: 0.65 },
    { name: "ウスターソース", price_per_gram: 0.6 },
    { name: "カレールー", price_per_gram: 1.45 },
    { name: "福神漬け", price_per_gram: 1.20 },
    { name: "紅生姜", price_per_gram: 1.20 },
    { name: "白ごま", price_per_gram: 1.50 },
    { name: "刻み海苔", price_per_gram: 5.80 },
    { name: "かつお節", price_per_gram: 4.50 },
    { name: "天かす", price_per_gram: 1.50 },
    { name: "乾燥わかめ", price_per_gram: 3.50 },
    { name: "七味唐辛子", price_per_gram: 12.0 },
    { name: "コショウ", price_per_gram: 8.5 },
    { name: "ラー油", price_per_gram: 4.5 },
    { name: "おろしにんにく(チューブ)", price_per_gram: 1.8 },
    { name: "おろし生姜(チューブ)", price_per_gram: 1.8 },
    { name: "コンソメ(顆粒)", price_per_gram: 2.8 },
    { name: "鶏ガラスープの素", price_per_gram: 2.5 },
    { name: "味覇", price_per_gram: 2.8 }
    ],
  "💰 その他（金額目安）" => [
      { name: "その他食材（100g/50円）", price_per_gram: 0.5 },
      { name: "その他食材（100g/100円）", price_per_gram: 1.0 },
      { name: "その他食材（100g/150円）", price_per_gram: 1.5 },
      { name: "その他食材（100g/200円）", price_per_gram: 2.0 },
      { name: "その他食材（100g/300円）", price_per_gram: 3.0 },
      { name: "その他食材（100g/500円）", price_per_gram: 5.0 }
    ]
}

ingredient_groups.each do |category_name, items|
  items.each do |item_data|
    Ingredient.find_or_create_by!(name: item_data[:name]) do |i|
      i.category = category_name
      i.price_per_gram = item_data[:price_per_gram]
    end
  end
end

puts "Success: Created #{Ingredient.count} ingredients with categories!"