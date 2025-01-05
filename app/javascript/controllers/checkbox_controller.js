import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["ceInc", "eqInc", "eqSap" , "cae", "cate"];

  connect() {

  }

  toggleEqInc() {
    // Check EQ_INC when CE_INC is checked, otherwise uncheck it
    if (this.ceIncTarget.checked) {
      this.eqIncTarget.checked = true;
      this.eqSapTarget.checked = true;
    } else {
      this.eqIncTarget.checked = false;
      this.eqSapTarget.checked = false;
    }
  }

  toggleCA1E() {
    if (this.cateTarget.checked) {
      this.caeTarget.checked = true;
    } else {
      this.caeTarget.checked = false;
    }
  }
}
