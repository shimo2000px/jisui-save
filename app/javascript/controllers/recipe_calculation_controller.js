import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 1. savingsDisplay をターゲットに追加
  static targets = ["row", "totalDisplay", "container", "template", "convenienceSelect", "conveniencePriceDisplay", "savingsDisplay"]

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

    if (this.hasConvenienceSelectTarget && this.hasSavingsDisplayTarget) {
      const cvsSelect = this.convenienceSelectTarget
      const cvsPrice = cvsSelect.selectedIndex > 0 
        ? parseFloat(cvsSelect.options[cvsSelect.selectedIndex].dataset.price) 
        : 0
      
      const savings = cvsPrice - total
      this.savingsDisplayTarget.textContent = Math.round(savings).toLocaleString()
      
      if (savings < 0) {
        this.savingsDisplayTarget.parentElement.classList.add('text-gray-400')
        this.savingsDisplayTarget.parentElement.classList.remove('text-orange-500')
      } else {
        this.savingsDisplayTarget.parentElement.classList.add('text-orange-500')
        this.savingsDisplayTarget.parentElement.classList.remove('text-gray-400')
      }
    }
  }

  updateComparison() {
    const select = this.convenienceSelectTarget
    let price = 0

    if (select.selectedIndex > 0) {
      const selectedOption = select.options[select.selectedIndex]
      price = parseFloat(selectedOption.dataset.price) || 0
    }

    if (this.hasConveniencePriceDisplayTarget) {
      this.conveniencePriceDisplayTarget.textContent = price.toLocaleString()
    }

    this.calculate() 
  }
}