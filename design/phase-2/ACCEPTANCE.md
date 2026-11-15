# Testing & Acceptance Criteria (Phase 2 Design → Future Implementation)

## Design-phase acceptance (now)

- [x] Final identity guide published
- [x] Exact tokens in JSON + CSS
- [x] Typography / icons specified
- [x] Component library specified
- [x] Five main screens refined in preview
- [x] Five Atmospheres specified (invariant vs variable)
- [x] Interactions / keyboard specified
- [x] Accessibility + performance requirements
- [x] Architecture + roadmap + this checklist
- [x] Previews openable without touching OS

## Implementation acceptance (after approval, per stage)

### Visual / coherence

- [ ] All shell chrome shares radii, spacing, accent, focus rings
- [ ] Atmospheres change only allowed variables
- [ ] No Vista/7 ornament; brand mark correct per context

### Interaction

- [ ] Only one overlay open at a time
- [ ] Esc closes overlay; focus restored
- [ ] Keyboard paths for launcher/CC/settings work
- [ ] Default desktop has no dock/widgets/desktop icons

### Efficiency

- [ ] `blur=off` default retained
- [ ] Idle RSS measured and compared to theme P0 baseline (~421 MiB)
- [ ] Reduced motion / transparency modes work
- [ ] No dual always-on panels

### Reliability

- [ ] Sway session survives shell crash; fallback panel available
- [ ] Theme apply does not require logout
- [ ] Live ISO still boots; OOBE still install-only

### Master roadmap

- [ ] Installer / OOBE / ISO verification not regressed
- [ ] LOGIN greeter unchanged until LOGIN milestone explicitly opened
