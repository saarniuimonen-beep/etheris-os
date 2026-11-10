/* Design Phase 1 preview helpers — atmosphere + a11y toggles */
(function () {
  const root = document.documentElement;
  const params = new URLSearchParams(location.search);
  const stored = localStorage.getItem("eth-atmosphere");
  const atm = params.get("atm") || stored || "ocean-glass";
  root.setAttribute("data-atmosphere", atm);

  if (params.get("motion") === "reduced" || localStorage.getItem("eth-motion") === "reduced") {
    root.setAttribute("data-motion", "reduced");
  }
  if (params.get("transparency") === "reduced" || localStorage.getItem("eth-transparency") === "reduced") {
    root.setAttribute("data-transparency", "reduced");
  }

  function setAtmosphere(name) {
    root.setAttribute("data-atmosphere", name);
    localStorage.setItem("eth-atmosphere", name);
    document.querySelectorAll(".atm-picker button").forEach((btn) => {
      btn.setAttribute("aria-pressed", btn.dataset.atm === name ? "true" : "false");
    });
    const label = document.querySelector("[data-atm-label]");
    if (label) label.textContent = name.replace(/-/g, " ");
  }

  document.querySelectorAll(".atm-picker button").forEach((btn) => {
    btn.addEventListener("click", () => setAtmosphere(btn.dataset.atm));
    btn.setAttribute("aria-pressed", btn.dataset.atm === atm ? "true" : "false");
  });

  const label = document.querySelector("[data-atm-label]");
  if (label) label.textContent = atm.replace(/-/g, " ");
})();
