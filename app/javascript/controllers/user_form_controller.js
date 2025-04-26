import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["companyField", "companySelect", "companyError"]

    connect() {
        this.toggleCompanyField()
    }

    toggleCompanyField() {
        const roleSelect = this.element.querySelector('select[name="user[role]"]')
        const isCustomer = roleSelect && roleSelect.value === "customer"

        if (this.hasCompanyFieldTarget) {
            if (isCustomer) {
                this.companyFieldTarget.classList.remove("hidden")
                this.companySelectTarget.setAttribute("required", "")
            } else {
                this.companyFieldTarget.classList.add("hidden")
                this.companySelectTarget.removeAttribute("required")
            }
        }
    }

    validateForm(event) {
        const roleSelect = this.element.querySelector('select[name="user[role]"]')
        const isCustomer = roleSelect && roleSelect.value === "customer"

        if (isCustomer && this.hasCompanySelectTarget && !this.companySelectTarget.value) {
            event.preventDefault()
            this.companyErrorTarget.style.display = "block"
            this.companySelectTarget.classList.add("border-red-500")
            this.companySelectTarget.focus()
        }
    }
} 