import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["totalDisplay", "container", "template", "convenienceSelect", "conveniencePriceDisplay", "savingsDisplay"]

  connect() {
    this.calculate()
  }

  add(event) {
    event.preventDefault()
    // ID重複なし
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
    this.calculate()
  }

  //既存レコードの削除
  remove(event) {
    event.preventDefault()
    const row = event.target.closest(".ingredient-row")
    const destroyField = row.querySelector('input[name*="_destroy"]')
    if (destroyField) {
      destroyField.value = "1"
      row.style.display = "none"
      row.classList.remove("ingredient-row")
    } else {
      row.remove() 
    }
    this.calculate()
  }

  // 合計金額の算出
  calculate() {
    let total = 0
    const activeRows = this.containerTarget.querySelectorAll(".ingredient-row")
    
    activeRows.forEach((row) => {
      const select = row.querySelector('select')
      const amountInput = row.querySelector('input[name*="amount_gram"]')
      const customPriceInput = row.querySelector('input[name*="custom_price"]')

      const amount = parseFloat(amountInput?.value) || 0
      const customPrice = customPriceInput?.value.trim()

      // 手動価格があればそちらを優先
      if (customPrice !== "" && !isNaN(customPrice)) {
        total += parseFloat(customPrice)
      } 
      // 材料計算の場合（手動金額がある場合）
      else if (select && select.selectedIndex > 0) {
        const selectedOption = select.options[select.selectedIndex]
        const pricePerGram = parseFloat(selectedOption.dataset.pricePerGram) || 0
        total += pricePerGram * amount
      }
    })

    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = Math.round(total).toLocaleString()
    }

    this.updateSavings(total)
  }

  // 節約額（比較コンビニ額 - レシピ額）
  updateSavings(total) {
    if (this.hasConvenienceSelectTarget && this.hasSavingsDisplayTarget) {
      const cvsSelect = this.convenienceSelectTarget
      const cvsPrice = cvsSelect.selectedIndex > 0 
        ? parseFloat(cvsSelect.options[cvsSelect.selectedIndex].dataset.price) 
        : 0
      
      const savings = cvsPrice - total
      this.savingsDisplayTarget.textContent = Math.round(savings).toLocaleString()
      
  // 節約できているかで色を切り替える
      const displayElement = this.savingsDisplayTarget.parentElement
      if (savings < 0) {
        displayElement.classList.add('text-gray-400')
        displayElement.classList.remove('text-orange-600')
      } else {
        displayElement.classList.add('text-orange-600')
        displayElement.classList.remove('text-gray-400')
      }
    }
  }

  // 比較商品が変更された場合の切り替え
  updateComparison() {
    const select = this.convenienceSelectTarget
    let price = 0
    if (select.selectedIndex > 0) {
      price = parseFloat(select.options[select.selectedIndex].dataset.price) || 0
    }
    if (this.hasConveniencePriceDisplayTarget) {
      this.conveniencePriceDisplayTarget.textContent = price.toLocaleString()
    }
    this.calculate() 
  }
}