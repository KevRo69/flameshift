import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="users-dropdown"
export default class extends Controller {
    static targets = ["select"]
    static values = { ignoreUserId: String }

    connect() {
        this.updateDropdowns()
    }

    updateDropdowns() {
        const selectedValues = this.selectTargets
            .map(dd => dd.value)
            .filter(value => value !== "")

        this.selectTargets.forEach(dropdown => {
            Array.from(dropdown.options).forEach(option => {
                if (selectedValues.includes(option.value) &&
                    option.value !== dropdown.value &&
                    option.value !== this.ignoreUserIdValue) {
                    option.hidden = true
                } else {
                    option.hidden = false
                }
            })
        })
    }

    change() {
        this.updateDropdowns()
    }
}
