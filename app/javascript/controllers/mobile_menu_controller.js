import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.closeMenu = this.closeMenu.bind(this)
    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleResize = this.handleResize.bind(this)

    document.addEventListener("click", this.closeMenu)
    document.addEventListener("keydown", this.handleKeyDown)
    window.addEventListener("resize", this.handleResize)
  }

  disconnect() {
    document.removeEventListener("click", this.closeMenu)
    document.removeEventListener("keydown", this.handleKeyDown)
    window.removeEventListener("resize", this.handleResize)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    const isHidden = this.menuTarget.classList.contains("hidden")
    this.buttonTarget?.setAttribute("aria-expanded", !isHidden)
    this.menuTarget.setAttribute("aria-hidden", isHidden)
  }

  closeMenu(e) {
    if (!this.element.contains(e.target) && !this.menuTarget.classList.contains("hidden")) {
      this.close()
    }
  }

  handleKeyDown(e) {
    if (e.key === "Escape" && !this.menuTarget.classList.contains("hidden")) {
      this.close()
      this.buttonTarget?.focus()
    }
  }

  handleResize() {
    if (window.innerWidth >= 768) {
      this.close()
    }
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.buttonTarget?.setAttribute("aria-expanded", "false")
    this.menuTarget.setAttribute("aria-hidden", "true")
  }
}
