import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["month", "year"];

  connect() {
  }

  updateCares() {
    const month = this.monthTarget.value;
    const year = this.yearTarget.value;

    const url = new URL(window.location.href);
    url.searchParams.set('month', month);
    url.searchParams.set('year', year);

    // Reload the page with the updated URL parameters
    window.location.href = url.toString();
  }
}
