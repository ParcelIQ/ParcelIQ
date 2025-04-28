import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["companyField", "companySelect", "companyError"]

    connect() {
        this.toggleCompanyField()
    }

    toggleCompanyField() {
        const roleSelect = this.element.querySelector('select[name*="[role]"]')

        if (!roleSelect) return

        const selectedRole = roleSelect.value

        if (selectedRole === "customer") {
            this.companyFieldTarget.style.display = "block"
            this.companySelectTarget.required = true
        } else {
            this.companyFieldTarget.style.display = "none"
            this.companySelectTarget.required = false
            this.companyErrorTarget.style.display = "none"
        }
    }

    validateForm(event) {
        const roleSelect = this.element.querySelector('select[name*="[role]"]')

        if (!roleSelect) return

        const selectedRole = roleSelect.value

        if (selectedRole === "customer" && !this.companySelectTarget.value) {
            event.preventDefault()
            this.companyErrorTarget.style.display = "block"
            this.companySelectTarget.classList.add("border-red-500")
            this.companySelectTarget.focus()
        } else {
            this.companyErrorTarget.style.display = "none"
            this.companySelectTarget.classList.remove("border-red-500")
        }
    }
} 