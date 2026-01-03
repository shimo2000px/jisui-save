puts "Deleting existing convenience foods..."
ConvenienceFood.destroy_all

convenience_foods = [
  # --- お弁当・御膳 ---
  { name: "幕の内弁当", price: 598 },
  { name: "海苔弁当", price: 480 },
  { name: "チキン南蛮弁当", price: 650 },
  { name: "ハンバーグ弁当", price: 680 },
  { name: "焼肉弁当", price: 720 },
  { name: "とんかつ弁当", price: 700 },
  { name: "三色そぼろ弁当", price: 450 },
  { name: "肉野菜炒め弁当", price: 560 },
  { name: "豚肉の生姜焼き弁当", price: 598 },
  { name: "レバニラ炒め弁当", price: 580 },
  { name: "回鍋肉弁当", price: 620 },
  { name: "鶏と野菜の黒酢あん弁当", price: 650 },
  { name: "八宝菜丼", price: 590 },
  { name: "野菜たっぷりタンメン", price: 550 },
  { name: "デミグラスハンバーグ弁当", price: 680 },
  { name: "おろしポン酢ハンバーグ弁当", price: 650 },
  { name: "鶏の照り焼き弁当", price: 590 },
  { name: "スタミナ豚焼肉丼", price: 580 },
  { name: "特製ロースかつ丼", price: 640 },
  { name: "おつまみ冷製チャーシュー", price: 380 },
  { name: "油淋鶏(単品/惣菜)", price: 450 },
  { name: "銀鮭塩焼の御膳", price: 690 },
  { name: "縞ほっけの塩焼き弁当", price: 720 },
  { name: "鯖の味噌煮弁当", price: 600 },
  { name: "鮭塩焼弁当", price: 620 },


  # --- 丼物・カレー ---
  { name: "特製牛丼", price: 530 },
  { name: "親子丼", price: 500 },
  { name: "カツ丼", price: 580 },
  { name: "麻婆豆腐丼", price: 480 },
  { name: "チキンカレー", price: 580 },
  { name: "キーマカレー", price: 600 },
  { name: "カツカレー", price: 750 },
  { name: "バターチキンカレー", price: 650 },
  { name: "海老グラタン", price: 450 },
  { name: "ミートドリア", price: 450 },
  { name: "オムライス", price: 520 },

  # --- 麺類 ---
  { name: "醤油ラーメン", price: 550 },
  { name: "味噌ラーメン", price: 580 },
  { name: "豚骨ラーメン", price: 620 },
  { name: "こってりラーメン", price: 700 },
  { name: "冷やし中華(夏季)", price: 590 },
  { name: "カルボナーラパスタ", price: 580 },
  { name: "ミートソースパスタ", price: 550 },
  { name: "ナポリタン", price: 490 },
  { name: "明太子パスタ", price: 560 },
  { name: "和風パスタ", price: 520 },
  { name: "冷したぬきうどん", price: 460 },
  { name: "肉うどん", price: 580 },
  { name: "ソース焼きそば", price: 450 },

  # --- おにぎり・サンドイッチ ---
  { name: "おにぎり(鮭)", price: 180 },
  { name: "おにぎり(梅)", price: 140 },
  { name: "おにぎり(ツナマヨ)", price: 160 },
  { name: "おにぎり(明太子)", price: 190 },
  { name: "ミックスサンド", price: 320 },
  { name: "レタスハムサンド", price: 300 },
  { name: "たまごサンド", price: 280 },
  { name: "カツサンド", price: 450 },

  # --- 惣菜・ホットスナック ---
  { name: "レジ横唐揚げ", price: 240 },
  { name: "ファミチキ風チキン", price: 220 },
  { name: "肉じゃが(惣菜パック)", price: 350 },
  { name: "海老のチリソース炒め(惣菜)", price: 480 },
  { name: "きんぴらごぼう(小)", price: 200 },
  { name: "ひじき煮(小)", price: 200 },
  { name: "ポテトサラダ", price: 250 },
  { name: "コールスローサラダ", price: 230 },
  { name: "餃子(5個)", price: 280 },
  { name: "焼売(6個)", price: 320 },
  { name: "筑前煮(パウチ)", price: 280 },
  { name: "かぼちゃ煮(小)", price: 180 },
  { name: "きんぴらごぼう(パウチ)", price: 150 },
  { name: "ひじき煮(パウチ)", price: 150 },
  { name: "切り干し大根(パウチ)", price: 160 },
  { name: "ほうれん草の胡麻和え", price: 220 },
  { name: "ポテトサラダ(大)", price: 350 },
  { name: "マカロニサラダ", price: 240 },
  { name: "卯の花(パウチ)", price: 160 },

  # --- サラダ・健康系 ---
  { name: "1/2日分の野菜サラダ", price: 450 },
  { name: "ラーメンサラダ", price: 420 },
  { name: "豚しゃぶサラダ", price: 480 },
  { name: "豆腐ハンバーグ(惣菜)", price: 320 },
  { name: "チョレギサラダ", price: 380 },

  # --- その他・軽食 ---
  { name: "お好み焼き", price: 550 },
  { name: "たこ焼き(6個)", price: 480 },
  { name: "ナゲット(5個)", price: 260 },
  { name: "アメリカンドッグ", price: 140 },
  { name: "春巻(1本)", price: 110 },

  # --- スープ・カップ麺類 ---
  { name: "豚汁", price: 230 },
  { name: "ミネストローネ", price: 180 },
  { name: "コーンポタージュ", price: 180 },
  { name: "カップヌードル", price: 240 },
  { name: "カップ焼きそば", price: 240 },
]

convenience_foods.each do |data|
  ConvenienceFood.create!(data)
end

puts "Success: Created #{ConvenienceFood.count} convenience foods master data!"