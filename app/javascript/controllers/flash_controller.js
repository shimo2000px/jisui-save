import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    this.element.style.opacity = "0"
    this.element.style.transition = "opacity 0.5s ease"
    
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}