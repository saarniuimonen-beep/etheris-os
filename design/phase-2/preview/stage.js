(function () {
  const root = document.documentElement;
  const params = new URLSearchParams(location.search);
  const atm = params.get("atm") || localStorage.getItem("eth2-atmosphere") || "ocean-glass";
  root.setAttribute("data-atmosphere", atm);
  if (params.get("motion") === "reduced" || localStorage.getItem("eth2-motion") === "reduced") {
    root.setAttribute("data-motion", "reduced");
  }
  if (params.get("transparency") === "reduced" || localStorage.getItem("eth2-transparency") === "reduced") {
    root.setAttribute("data-transparency", "reduced");
  }
  function setAtmosphere(name) {
    root.setAttribute("data-atmosphere", name);
    localStorage.setItem("eth2-atmosphere", name);
    document.querySelectorAll(".atm-picker button").forEach((btn) => {
      btn.setAttribute("aria-pressed", btn.dataset.atm === name ? "true" : "false");
    });
  }
  document.querySelectorAll(".atm-picker button").forEach((btn) => {
    btn.addEventListener("click", () => setAtmosphere(btn.dataset.atm));
    btn.setAttribute("aria-pressed", btn.dataset.atm === atm ? "true" : "false");
  });
})();
