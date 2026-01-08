import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const index = this.containerTarget.children.length + 1
    const content = this.templateTarget.innerHTML.replace(/NEW_INDEX/g, index)
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  // 追加：削除ボタンが押された要素を消去する
  remove(event) {
    event.preventDefault()
    // クリックされたボタンの親要素（ステップの枠）を探して削除
    const item = event.target.closest(".step-item")
    item.remove()
    
    // 番号を振り直す（任意ですが、あったほうが親切です）
    this.reindex()
  }

  // 番号を1から順に更新する
  reindex() {
    this.containerTarget.querySelectorAll(".step-number").forEach((el, i) => {
      el.textContent = i + 1
    })
  }
}