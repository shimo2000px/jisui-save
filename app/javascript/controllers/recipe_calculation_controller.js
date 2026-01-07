import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // totalDisplay だけを staticTargets に残し、他は各行の中で探します
  static targets = ["totalDisplay", "row"]

  connect() {
    this.calculate()
  }

  calculate() {
    console.log("計算関数が呼ばれました！")
    let total = 0

    // 各行（data-recipe-calculation-target="row"）をループ
    this.rowTargets.forEach((row) => {
      // row(行)の中から、セレクトボックス・分量・手動金額の要素を直接探す
      const select = row.querySelector('select')
      const amountInput = row.querySelector('input[name*="amount_gram"]')
      const customPriceInput = row.querySelector('input[name*="custom_price"]')

      const amount = parseFloat(amountInput.value) || 0
      const customPrice = customPriceInput.value.trim()

      if (customPrice !== "") {
        // 手動入力があれば優先
        total += parseFloat(customPrice) || 0
      } else if (select && select.selectedIndex > 0) {
        // 材料の単価を取得
        const selectedOption = select.options[select.selectedIndex]
        const pricePerGram = parseFloat(selectedOption.dataset.pricePerGram) || 0
        total += pricePerGram * amount
      }
    })

    // 合計金額を画面に反映
    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = Math.round(total).toLocaleString()
    }
  }
}