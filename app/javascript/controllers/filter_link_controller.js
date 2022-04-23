import { Controller } from 'stimulus'
export default class extends Controller {
  static targets = ['link']

  connect() {
    this.isStable = true
  }

  markUnstable() {
    this.isStable = false
    this.linkTarget.disabled = true
  }

  markStable() {
    this.isStable = true
    this.linkTarget.disabled = false
  }
}
