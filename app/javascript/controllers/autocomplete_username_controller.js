import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="autocomplete-username"
export default class extends Controller {
  static targets = ["firstName", "lastName", "username"];
  connect() {
  }

  updateUsername() {
    const firstName = this.firstNameTarget.value.trim();
    const lastName = this.lastNameTarget.value.trim();

    if (firstName && lastName) {
      this.usernameTarget.value = firstName.toLowerCase() + lastName.charAt(0).toLowerCase();
    }
  }
}
