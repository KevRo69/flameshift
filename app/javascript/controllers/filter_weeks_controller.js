import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-weeks"
export default class extends Controller {
  static targets = ["week"];

  connect() {
  }

  filterWeek() {
    const week = this.weekTarget.value;

    const url = new URL(window.location.href);
    url.searchParams.set('week', week);

    // Reload the page with the updated URL parameters
    window.location.href = url.toString();
  }
}
