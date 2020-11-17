const Hooks = {};

Hooks.SetAmount = {
  mounted() {
    let input = this.el.closest("form").querySelector(".js-amount");
    let amount = this.el.dataset.amount;

    if (!input || !amount) {
      return;
    }

    this.el.addEventListener("click", (ev) => {
      ev.preventDefault();
      input.value = amount;
      this.el.dispatchEvent(new Event("change", { bubbles: true }));
    });
  },
};

export default Hooks;
