import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {

  static values = {
    availabilities: Array
  }

  connect() {
    console.log(this.availabilitiesValue);

    const today = new Date();
    let month = today.getMonth();
    let year = today.getFullYear();
    let minDate = new Date();
    let maxDate = new Date();
    if (today.getDate() < 16) {
      month = (today.getMonth() + 2)%12;
      if (today.getMonth() + 1 > 11){
        year = today.getFullYear() + 1;
      } else{
        year = today.getFullYear();
      }
    }
    else {
      month = (today.getMonth() + 2)%12;
      if (today.getMonth() + 3 > 11){
        year = today.getFullYear() + 1;
      } else{
        year = today.getFullYear();
      }
    }
    const months31 = [0, 2, 4, 6, 7, 9, 11];
    if (month === 1) {
      if (this.#isLeapYear(year)) {
        maxDate = new Date(year, month, 29);
      } else {
        maxDate = new Date(year, month, 28);
      }
    } else if (months31.includes(month)) {
      maxDate = new Date(year, month, 31);
    } else {
      maxDate = new Date(year, month, 30);
    }

    minDate = new Date(year, month, 1);

    flatpickr(this.element,
      {
        mode: "multiple",
        inline: true,
        dateFormat: "Y-m-d",
        minDate: minDate,
        maxDate: maxDate,
        defaultDate: this.availabilitiesValue,
        "disable": [
        function(date) {
            // return true to disable
            return (date.getDay() === 1 || date.getDay() === 2 || date.getDay() === 3 || date.getDay() === 4);
            }
        ],
        "locale": {
        "firstDayOfWeek": 1 // start week on Monday
        }
      }
    )
  }

  #isLeapYear(year) {
    // Create a date for February 29th of the given year
    const date = new Date(year, 1, 29); // Month 1 is February (zero-indexed)

    // Check if the month of the date is still February (month 1)
    return date.getMonth() === 1;
  }

  disconnect() {
    this.element._flatpickr.destroy();
  }
}
