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

    this.#checkUsername();
  }

    #checkUsername() {
        clearTimeout(this.checkTimeout);

        this.checkTimeout = setTimeout(() => {
            const username = this.usernameTarget.value.trim();
            if (username.length === 0) return;

            fetch(`/check_username?username=${encodeURIComponent(username)}`)
                .then((response) => response.json())
                .then((data) => {
                    data.exists === false ? this.usernameTarget.value = username : this.usernameTarget.value = `${username}${data.highest_username + 1}`;
                });
        }, 300);
    }
}
