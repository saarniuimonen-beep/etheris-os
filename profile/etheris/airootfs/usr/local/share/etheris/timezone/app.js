/* Etheris timezone globe — Three.js Earth + city search */
(function () {
  "use strict";

  const CITIES = window.ETHERIS_CITIES || [];
  const canvas = document.getElementById("globe");
  const host = document.getElementById("globe-host");
  const search = document.getElementById("search");
  const suggestions = document.getElementById("suggestions");
  const selName = document.getElementById("sel-name");
  const selMeta = document.getElementById("sel-meta");
  const selClock = document.getElementById("sel-clock");
  const selOffset = document.getElementById("sel-offset");
  const selFlag = document.getElementById("sel-flag");
  const selection = document.getElementById("selection");
  const autoTravel = document.getElementById("auto-travel");
  const btnConfirm = document.getElementById("btn-confirm");
  const btnSkip = document.getElementById("btn-skip");

  let selected = null;
  let clockTimer = null;
  let activeSug = -1;

  function flagEmoji(cc) {
    if (!cc || cc.length !== 2 || cc === "ZZ") return "🌐";
    const A = 127397;
    try {
      return String.fromCodePoint(...[...cc.toUpperCase()].map((c) => A + c.charCodeAt(0)));
    } catch (_) {
      return "🌐";
    }
  }

  function post(action, payload) {
    const msg = Object.assign({ action: action }, payload || {});
    const q = encodeURIComponent(JSON.stringify(msg));
    // Custom scheme intercepted by etheris-timezone (WebKit decide-policy).
    window.location.href = "etheris://timezone?" + q;
    try {
      if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.etheris) {
        window.webkit.messageHandlers.etheris.postMessage(msg);
      }
    } catch (_) {}
  }

  function prettyCity(c) {
    const leaf = (c.tz || "").split("/").pop().replace(/_/g, " ");
    return c.name || leaf || c.tz;
  }

  function formatOffset(tz) {
    try {
      const parts = new Intl.DateTimeFormat("en-US", {
        timeZone: tz,
        timeZoneName: "shortOffset",
      }).formatToParts(new Date());
      const off = parts.find((p) => p.type === "timeZoneName");
      return off ? off.value : "";
    } catch (_) {
      return "";
    }
  }

  function localTime(tz) {
    try {
      return new Intl.DateTimeFormat(undefined, {
        timeZone: tz,
        weekday: "short",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
      }).format(new Date());
    } catch (_) {
      return "";
    }
  }

  function setSelected(city, fly) {
    selected = city;
    selName.textContent = prettyCity(city);
    const off = formatOffset(city.tz);
    selMeta.textContent = city.tz + (city.country ? " · " + city.country : "");
    if (selOffset) selOffset.textContent = off || "";
    if (selFlag) selFlag.textContent = flagEmoji(city.country);
    if (selection) selection.classList.add("ready");
    btnConfirm.disabled = !city.tz;
    if (clockTimer) clearInterval(clockTimer);
    const tick = () => {
      selClock.textContent = localTime(city.tz);
    };
    tick();
    clockTimer = setInterval(tick, 1000);
    if (fly) flyTo(city.lat, city.lon);
    highlightMarker(city);
  }

  function searchCities(q) {
    q = (q || "").trim().toLowerCase();
    if (!q) return [];
    const scored = [];
    for (let i = 0; i < CITIES.length; i++) {
      const c = CITIES[i];
      const name = prettyCity(c).toLowerCase();
      const tz = (c.tz || "").toLowerCase();
      let score = -1;
      if (name.startsWith(q)) score = 100 - name.length;
      else if (name.includes(q)) score = 60 - name.length;
      else if (tz.includes(q.replace(/\s+/g, "_"))) score = 40;
      else if ((c.country || "").toLowerCase() === q) score = 30;
      if (score >= 0) scored.push({ score: score, city: c });
    }
    scored.sort((a, b) => b.score - a.score);
    return scored.slice(0, 12).map((x) => x.city);
  }

  function renderSuggestions(list) {
    suggestions.innerHTML = "";
    activeSug = -1;
    if (!list.length) {
      suggestions.hidden = true;
      return;
    }
    list.forEach((c, idx) => {
      const li = document.createElement("li");
      li.innerHTML = "<strong>" + prettyCity(c) + "</strong><span class='tz'>" + c.tz + "</span>";
      li.addEventListener("mousedown", (e) => {
        e.preventDefault();
        setSelected(c, true);
        suggestions.hidden = true;
        search.value = prettyCity(c);
      });
      li.dataset.idx = String(idx);
      suggestions.appendChild(li);
    });
    suggestions.hidden = false;
  }

  search.addEventListener("input", () => {
    renderSuggestions(searchCities(search.value));
  });
  search.addEventListener("keydown", (e) => {
    const items = suggestions.querySelectorAll("li");
    if (e.key === "ArrowDown" && items.length) {
      e.preventDefault();
      activeSug = Math.min(activeSug + 1, items.length - 1);
      items.forEach((el, i) => el.classList.toggle("active", i === activeSug));
    } else if (e.key === "ArrowUp" && items.length) {
      e.preventDefault();
      activeSug = Math.max(activeSug - 1, 0);
      items.forEach((el, i) => el.classList.toggle("active", i === activeSug));
    } else if (e.key === "Enter") {
      e.preventDefault();
      if (activeSug >= 0 && items[activeSug]) items[activeSug].dispatchEvent(new Event("mousedown"));
      else {
        const hit = searchCities(search.value)[0];
        if (hit) {
          setSelected(hit, true);
          suggestions.hidden = true;
          search.value = prettyCity(hit);
        }
      }
    } else if (e.key === "Escape") {
      suggestions.hidden = true;
    }
  });

  btnConfirm.addEventListener("click", () => {
    if (!selected) return;
    post("confirm", {
      tz: selected.tz,
      name: prettyCity(selected),
      lat: selected.lat,
      lon: selected.lon,
      country: selected.country || "",
      auto: !!(autoTravel && autoTravel.checked),
    });
  });
  btnSkip.addEventListener("click", () =>
    post("skip", { auto: !!(autoTravel && autoTravel.checked) })
  );

  /* ---------- Three.js globe ---------- */
  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(42, 1, 0.1, 100);
  camera.position.set(0, 0.35, 3.35);

  const renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
  renderer.setClearColor(0x000000, 0);

  const ambient = new THREE.AmbientLight(0x6ec8ff, 0.55);
  scene.add(ambient);
  const sun = new THREE.DirectionalLight(0xfff2dd, 1.35);
  sun.position.set(5, 2, 3);
  scene.add(sun);

  const earthGroup = new THREE.Group();
  scene.add(earthGroup);

  const globeRadius = 1.0;
  const earthGeo = new THREE.SphereGeometry(globeRadius, 96, 96);
  const earthMat = new THREE.MeshPhongMaterial({
    color: 0x1a6bb5,
    specular: 0x335566,
    shininess: 12,
    transparent: false,
  });
  const earth = new THREE.Mesh(earthGeo, earthMat);
  earthGroup.add(earth);

  const loader = new THREE.TextureLoader();
  loader.load(
    "earth.jpg",
    (tex) => {
      tex.colorSpace = THREE.SRGBColorSpace || THREE.sRGBEncoding;
      earthMat.map = tex;
      earthMat.color = new THREE.Color(0xffffff);
      earthMat.needsUpdate = true;
    },
    undefined,
    () => {
      /* procedural fallback already visible */
    }
  );

  const atmosGeo = new THREE.SphereGeometry(globeRadius * 1.045, 64, 64);
  const atmosMat = new THREE.MeshBasicMaterial({
    color: 0x38bdf8,
    transparent: true,
    opacity: 0.12,
    side: THREE.BackSide,
  });
  earthGroup.add(new THREE.Mesh(atmosGeo, atmosMat));

  // starfield
  const starGeo = new THREE.BufferGeometry();
  const starCount = 1200;
  const starPos = new Float32Array(starCount * 3);
  for (let i = 0; i < starCount; i++) {
    const r = 20 + Math.random() * 40;
    const theta = Math.random() * Math.PI * 2;
    const phi = Math.acos(2 * Math.random() - 1);
    starPos[i * 3] = r * Math.sin(phi) * Math.cos(theta);
    starPos[i * 3 + 1] = r * Math.sin(phi) * Math.sin(theta);
    starPos[i * 3 + 2] = r * Math.cos(phi);
  }
  starGeo.setAttribute("position", new THREE.BufferAttribute(starPos, 3));
  scene.add(new THREE.Points(starGeo, new THREE.PointsMaterial({ color: 0xa8d8ff, size: 0.035 })));

  const markers = new THREE.Group();
  earthGroup.add(markers);
  const markerGeo = new THREE.SphereGeometry(0.012, 10, 10);
  const markerMat = new THREE.MeshBasicMaterial({ color: 0x7dd3fc });
  const markerMatActive = new THREE.MeshBasicMaterial({ color: 0x2dd4bf });
  const markerMeshes = [];

  function latLonToVec3(lat, lon, r) {
    const phi = (90 - lat) * (Math.PI / 180);
    const theta = (lon + 180) * (Math.PI / 180);
    return new THREE.Vector3(
      -r * Math.sin(phi) * Math.cos(theta),
      r * Math.cos(phi),
      r * Math.sin(phi) * Math.sin(theta)
    );
  }

  // denser markers: sample cities (cap for performance)
  const markerCities = CITIES.length > 900 ? CITIES.filter((_, i) => i % 2 === 0) : CITIES;
  markerCities.forEach((c) => {
    const m = new THREE.Mesh(markerGeo, markerMat);
    m.position.copy(latLonToVec3(c.lat, c.lon, globeRadius * 1.01));
    m.userData.city = c;
    markers.add(m);
    markerMeshes.push(m);
  });

  let activeMarker = null;
  function highlightMarker(city) {
    if (activeMarker) activeMarker.material = markerMat;
    activeMarker = null;
    for (let i = 0; i < markerMeshes.length; i++) {
      const m = markerMeshes[i];
      if (m.userData.city && m.userData.city.tz === city.tz &&
          Math.abs(m.userData.city.lat - city.lat) < 0.2 &&
          Math.abs(m.userData.city.lon - city.lon) < 0.2) {
        m.material = markerMatActive;
        activeMarker = m;
        break;
      }
    }
  }

  function flyTo(lat, lon) {
    targetRotY = (-lon) * (Math.PI / 180);
    targetRotX = (lat) * (Math.PI / 180) * 0.85;
  }

  function nearestCity(lat, lon) {
    let best = null;
    let bestD = Infinity;
    for (let i = 0; i < CITIES.length; i++) {
      const c = CITIES[i];
      const dlat = c.lat - lat;
      const dlon = c.lon - lon;
      const d = dlat * dlat + dlon * dlon;
      if (d < bestD) {
        bestD = d;
        best = c;
      }
    }
    return best;
  }

  function vecToLatLon(v) {
    const r = v.length();
    const lat = 90 - (Math.acos(v.y / r) * 180) / Math.PI;
    let lon = ((Math.atan2(v.z, -v.x) * 180) / Math.PI) - 180;
    if (lon < -180) lon += 360;
    if (lon > 180) lon -= 360;
    return { lat: lat, lon: lon };
  }

  /* interaction */
  let dragging = false;
  let moved = false;
  let lastX = 0;
  let lastY = 0;
  let rotY = 0.6;
  let rotX = 0.25;
  let targetRotY = rotY;
  let targetRotX = rotX;
  let autoSpin = true;
  let zoom = 3.35;

  function onPointerDown(e) {
    dragging = true;
    moved = false;
    autoSpin = false;
    lastX = e.clientX;
    lastY = e.clientY;
    canvas.setPointerCapture(e.pointerId);
  }
  function onPointerMove(e) {
    if (!dragging) return;
    const dx = e.clientX - lastX;
    const dy = e.clientY - lastY;
    if (Math.abs(dx) + Math.abs(dy) > 3) moved = true;
    targetRotY += dx * 0.005;
    targetRotX += dy * 0.005;
    targetRotX = Math.max(-1.2, Math.min(1.2, targetRotX));
    lastX = e.clientX;
    lastY = e.clientY;
  }
  function onPointerUp(e) {
    if (!dragging) return;
    dragging = false;
    try { canvas.releasePointerCapture(e.pointerId); } catch (_) {}
    if (!moved) pickAt(e.clientX, e.clientY);
  }
  function onWheel(e) {
    e.preventDefault();
    zoom += e.deltaY * 0.0015;
    zoom = Math.max(2.1, Math.min(5.5, zoom));
  }

  canvas.addEventListener("pointerdown", onPointerDown);
  canvas.addEventListener("pointermove", onPointerMove);
  canvas.addEventListener("pointerup", onPointerUp);
  canvas.addEventListener("wheel", onWheel, { passive: false });

  const raycaster = new THREE.Raycaster();
  const pointer = new THREE.Vector2();

  function pickAt(clientX, clientY) {
    const rect = canvas.getBoundingClientRect();
    pointer.x = ((clientX - rect.left) / rect.width) * 2 - 1;
    pointer.y = -((clientY - rect.top) / rect.height) * 2 + 1;
    raycaster.setFromCamera(pointer, camera);

    const hits = raycaster.intersectObject(earth);
    if (!hits.length) return;
    // Convert hit point from world → earth local (account for group rotation)
    const local = earthGroup.worldToLocal(hits[0].point.clone());
    const ll = vecToLatLon(local);
    const city = nearestCity(ll.lat, ll.lon);
    if (city) {
      setSelected(city, false);
      search.value = prettyCity(city);
      suggestions.hidden = true;
      highlightMarker(city);
    }
  }

  function resize() {
    const w = host.clientWidth;
    const h = host.clientHeight;
    if (w < 2 || h < 2) return;
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
    renderer.setSize(w, h, false);
  }
  window.addEventListener("resize", resize);
  resize();

  function animate() {
    requestAnimationFrame(animate);
    if (autoSpin) targetRotY += 0.0012;
    rotY += (targetRotY - rotY) * 0.08;
    rotX += (targetRotX - rotX) * 0.08;
    earthGroup.rotation.y = rotY;
    earthGroup.rotation.x = rotX;
    camera.position.z += (zoom - camera.position.z) * 0.08;
    renderer.render(scene, camera);
  }
  animate();

  // Prefer geo IP / locale guess: pick timezone matching system if present
  try {
    const guess = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const hit = CITIES.find((c) => c.tz === guess) || CITIES.find((c) => c.tz.split("/")[0] === (guess || "").split("/")[0]);
    if (hit) setSelected(hit, true);
  } catch (_) {}

  search.focus();
})();
