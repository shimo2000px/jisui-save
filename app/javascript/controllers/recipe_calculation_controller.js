import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // totalDisplay をターゲットに含める
  static targets = ["totalDisplay", "container", "template", "convenienceSelect", "conveniencePriceDisplay", "savingsDisplay"]

  connect() {
    this.calculate()
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
    this.calculate()
  }

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

  calculate() {
    let total = 0
    const activeRows = this.containerTarget.querySelectorAll(".ingredient-row")
    
    activeRows.forEach((row) => {
      const select = row.querySelector('select')
      const amountInput = row.querySelector('input[name*="amount_gram"]')
      const customPriceInput = row.querySelector('input[name*="custom_price"]')

      const amount = parseFloat(amountInput?.value) || 0
      const customPrice = customPriceInput?.value.trim()

      if (customPrice !== "" && !isNaN(customPrice)) {
        // 手動入力があれば優先
        total += parseFloat(customPrice)
      } else if (select && select.selectedIndex > 0) {
        // セレクトボックスから計算
        const selectedOption = select.options[select.selectedIndex]
        const pricePerGram = parseFloat(selectedOption.dataset.pricePerGram) || 0
        total += pricePerGram * amount
      }
    })

    // 表示を更新
    if (this.hasTotalDisplayTarget) {
      this.totalDisplayTarget.textContent = Math.round(total).toLocaleString()
    }

    this.updateSavings(total)
  }

  updateSavings(total) {
    if (this.hasConvenienceSelectTarget && this.hasSavingsDisplayTarget) {
      const cvsSelect = this.convenienceSelectTarget
      const cvsPrice = cvsSelect.selectedIndex > 0 
        ? parseFloat(cvsSelect.options[cvsSelect.selectedIndex].dataset.price) 
        : 0
      
      const savings = cvsPrice - total
      this.savingsDisplayTarget.textContent = Math.round(savings).toLocaleString()
      
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