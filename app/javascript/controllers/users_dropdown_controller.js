import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="users-dropdown"
export default class extends Controller {
    static targets = ["select"]

    connect() {
        this.updateDropdowns()
    }

    updateDropdowns() {
        const selectedValues = this.selectTargets
            .map(dd => dd.value)
            .filter(value => value !== "")

        this.selectTargets.forEach(dropdown => {
            Array.from(dropdown.options).forEach(option => {
                if (selectedValues.includes(option.value) && option.value !== dropdown.value) {
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
