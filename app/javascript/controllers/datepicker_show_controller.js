import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {

  static values = {
    availabilities: Array,
    cod: Object,
    cate: Object,
    ca1e: Object,
    ceinc: Object,
    eqinc: Object,
    eqsap: Object,
    stg: Object,
    month: Number,
  }

  connect() {
    const today = new Date();
    let month = today.getMonth();
    let year = today.getFullYear();
    let minDate = new Date();
    let maxDate = new Date();
    if (today.getDate() < 16) {
      month = (today.getMonth() + 1 + this.monthValue) % 12;
      if (today.getMonth() + 1 + this.monthValue > 11){
        year = today.getFullYear() + 1;
      } else{
        year = today.getFullYear();
      }
    }
    else {
      month = (today.getMonth() + 2 + this.monthValue) % 12;
      if (today.getMonth() + 2 + this.monthValue > 11){
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
        },
        onReady: this.addDayHoverListeners.bind(this), // Call after calendar is rendered
        onChange: this.addDayHoverListeners.bind(this), // Re-attach listeners after date selection
      }
    )
  }

  #isLeapYear(year) {
    // Create a date for February 29th of the given year
    const date = new Date(year, 1, 29); // Month 1 is February (zero-indexed)

    // Check if the month of the date is still February (month 1)
    return date.getMonth() === 1;
  }

  addDayHoverListeners(selectedDates, dateStr, instance) {
    const calendar = instance.calendarContainer; // The container for the flatpickr calendar

    if (calendar) {
      const days = calendar.querySelectorAll(".flatpickr-day");

      days.forEach((day) => {
        // Remove existing listeners before re-attaching
        day.removeEventListener("mouseenter", this.showTooltip);
        day.removeEventListener("mouseleave", this.hideTooltip);

        // Add event listeners for tooltip functionality
        day.addEventListener("mouseenter", (event) => this.showTooltip(event, day));
        day.addEventListener("mouseleave", () => this.hideTooltip());
      });
    }
  }

  showTooltip(event, day) {
    // Check if the tooltip exists, and remove it if necessary
    this.removeTooltip();  // Ensure old tooltips are removed before creating new ones
    const frenchMonths = {
      janvier: '01',
      février: '02',
      mars: '03',
      avril: '04',
      mai: '05',
      juin: '06',
      juillet: '07',
      août: '08',
      septembre: '09',
      octobre: '10',
      novembre: '11',
      décembre: '12'
    };

    // Split the input string
    const [monthName, other_day, year] = day.getAttribute("aria-label").toLowerCase().split(' ');

    // Convert the French month name to the corresponding number
    const monthNumber = frenchMonths[monthName];

    const cleanDay = other_day.replace(',', '');

    // Ensure the day has two digits
    const formattedDay = cleanDay.padStart(2, '0');

    // Format the output as "dYYYY_MM_DD"
    const formattedDate = `d${year}_${monthNumber}_${formattedDay}`;
    let tooltipText = "";
    const codValue = this.codValue[formattedDate] ?? 0;
    const cateValue = this.cateValue[formattedDate] ?? 0;
    const ca1eValue = this.ca1eValue[formattedDate] ?? 0;
    const ceincValue = this.ceincValue[formattedDate] ?? 0;
    const eqincValue = this.eqincValue[formattedDate] ?? 0;
    const eqsapValue = this.eqsapValue[formattedDate] ?? 0;
    const stgValue = this.stgValue[formattedDate] ?? 0;
    tooltipText = `
                        COD1: ${codValue}<br>
                        CATE: ${cateValue}<br>
                        CA1E: ${ca1eValue}<br>
                        CEINC: ${ceincValue}<br>
                        EQINC: ${eqincValue}<br>
                        EQSAP: ${eqsapValue}<br>
                        STG: ${stgValue}
    `;
    this.createTooltip(tooltipText, event.clientX, event.clientY);
  }

  createTooltip(text, x, y) {
    // Create a new tooltip if it doesn't exist
    if (!this.tooltip) {
      this.tooltip = document.createElement("div");
      this.tooltip.className = "datepicker-tooltip";
      document.body.appendChild(this.tooltip);
    }

    this.tooltip.innerHTML = text;
    this.tooltip.style.position = "absolute";
    this.tooltip.style.left = `${x + 10}px`; // Offset slightly from cursor
    this.tooltip.style.top = `${y + 10}px`;
    this.tooltip.style.display = "block";
  }

  hideTooltip() {
    if (this.tooltip) {
      this.tooltip.style.display = "none";
    }
  }

  removeTooltip() {
    if (this.tooltip) {
      this.tooltip.remove(); // Remove any old tooltips before creating a new one
      this.tooltip = null; // Set the tooltip variable to null so a new one can be created
    }
  }

  disconnect() {
    this.element._flatpickr.destroy();
  }
}
