import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const index = this.containerTarget.children.length + 1
    const content = this.templateTarget.innerHTML.replace(/NEW_INDEX/g, index)
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest(".step-item")
    item.remove()
    
    this.reindex()
  }

  reindex() {
    this.containerTarget.querySelectorAll(".step-number").forEach((el, i) => {
      el.textContent = i + 1
    })
  }
}