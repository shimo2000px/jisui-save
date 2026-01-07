import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "totalDisplay", "container", "template"]

  connect() {
    this.calculate()
  }

  // --- 追加機能 ---
  add(event) {
    event.preventDefault()
    // テンプレートから新しい行を作成
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
    this.calculate()
  }

  // --- 削除機能 ---
  remove(event) {
    event.preventDefault()
    const row = event.target.closest(".ingredient-row")
    // railsのnested_formでよく使う削除フラグ（_destroy）があれば値を1にする
    const destroyField = row.querySelector('input[name*="_destroy"]')
    if (destroyField) {
      destroyField.value = "1"
      row.style.display = "none" // 見た目上消す
      row.classList.remove("ingredient-row") // 計算対象から外すためのクラス除去
    } else {
      row.remove() 
    }
    this.calculate()
  }

  calculate() {
    let total = 0
    const activeRows = this.containerTarget.querySelectorAll(".ingredient-row")
    
    activeRows.forEach((row) => {
      const select = row.querySelector('select')
      const amountInput = row.querySelector('input[name*="amount_gram"]')
      const customPriceInput = row.querySelector('input[name*="custom_price"]')

      const amount = parseFloat(amountInput.value) || 0
      const customPrice = customPriceInput.value.trim()

      if (customPrice !== "") {
        total += parseFloat(customPrice) || 0
      } else if (select && select.selectedIndex > 0) {
        const selectedOption = select.options[select.selectedIndex]
        const pricePerGram = parseFloat(selectedOption.dataset.pricePerGram) || 0
        total += pricePerGram * amount
      }
    })

    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = Math.round(total).toLocaleString()
    }
  }
}