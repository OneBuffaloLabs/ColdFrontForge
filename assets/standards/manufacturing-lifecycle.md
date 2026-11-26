# Manufacturing Lifecycle & Production Readiness Standard

**Cold Front Forge // One Buffalo Labs**  
*Internal Engineering Standard — Revision 1.0 (2026)*

---

## 1. Overview & Purpose

To ensure that every physical product manufactured and sold through **Cold Front Forge** meets industrial standards for precision, dimensional stability, print repeatability, and hardware fit, all designs must progress through strict, sequential **Manufacturing Lifecycle Stages**.

No design may be listed commercially or released to production without meeting all gate criteria for **Stage 4: Production Ready**.

---

## 2. Standard Lifecycle Stages

| Stage | Name | Visual Identifier | Badge Snippet | Purpose & Description |
| :---: | :--- | :---: | :--- | :--- |
| **Stage 1** | **Concept & Setup** | 🟡 `DRAFT` | `![Status: Draft](https://img.shields.io/badge/Status-Draft-yellow?style=for-the-badge)` | Initial parametric geometry, research measurements, unverified clearances. No physical prints yet. |
| **Stage 2** | **Prototyping & Testing** | 🟠 `TESTING` | `![Status: Testing](https://img.shields.io/badge/Status-Testing-orange?style=for-the-badge)` | First master STLs generated. Test print coupons, tolerance fit swatches, and magnet gauges on print bed. |
| **Stage 3** | **Pilot Validation** | 🔵 `VALIDATION` | `![Status: Validation](https://img.shields.io/badge/Status-Validation-blue?style=for-the-badge)` | Physical parts assembled and evaluated. Press-fit hardware, mechanical mating, and high-speed slicer profiles tuned. |
| **Stage 4** | **Production Ready** | 🟢 `PRODUCTION` | `![Status: Production](https://img.shields.io/badge/Status-Production-green?style=for-the-badge)` | Locked CAD parameters, verified `.3mf` multi-part nesting plates, print time & filament cost documented, commercial packaging ready. |
| **Stage 5** | **Archived / Legacy** | ⚪ `ARCHIVED` | `![Status: Archived](https://img.shields.io/badge/Status-Archived-lightgrey?style=for-the-badge)` | Retired, superseded by a subsequent design revision, or discontinued commercial model. |

---

## 3. Stage Gates & Exit Criteria

Advancing a product from one stage to the next requires satisfying all checklist criteria for that gate:

```
[ Stage 1: Setup ] ──( Gate 1 )──> [ Stage 2: Testing ] ──( Gate 2 )──> [ Stage 3: Validation ] ──( Gate 3 )──> [ Stage 4: Production ]
```

### Gate 1: Progression to Testing
- [ ] Parametric OpenSCAD source code organized with Customizer headers.
- [ ] Verified zero non-manifold geometry (`openscad -o test.stl <file>.scad` outputs `Simple: yes`, `Genus: 0`).
- [ ] Passes vault syntax check with zero warnings (`make lint`).
- [ ] Source file length conforms to max 325-line architectural guard.
- [ ] Target hardware standard defined (e.g. 5x2mm Neodymium magnet, M3 socket head).

### Gate 2: Progression to Pilot Validation
- [ ] Tolerance calibration coupon or fit gauge printed on production platform (Creality K2 SE).
- [ ] Female cavity clearances validated (e.g. 4.85mm 3-rib crush sockets grip magnet firmly without splitting layers).
- [ ] Mating surfaces and sliding tolerances tested (e.g. toploader slip-fit, cap collar clearance).
- [ ] Text legibility confirmed under target nozzle width (minimum 3.70mm font size for 0.4mm nozzle with Arachne).

### Gate 3: Progression to Production Ready
- [ ] Full 1:1 first article printed and fully assembled with production hardware.
- [ ] Sliced production `.3mf` plate committed under `models/production/` with locked layer heights and print times.
- [ ] Dual-color filament swaps or text layer height modifiers verified in slicer preview.
- [ ] Packaging container & shipping box size verified (e.g. Bubble Mailer #00, 6x4x2 in box).
- [ ] Commercial specs finalized: Internal SKU, weight (g), print duration, and storefront copy.

---

## 4. Current Active Product Registry

| Product | Internal SKU | Current Stage | Primary Platform / Material | Hardware Standard |
| :--- | :--- | :---: | :--- | :--- |
| **Cold Snap Tag** | `CFF-TCG-TAG` | 🔵 **Validation** | Creality K2 SE / PLA+ (Dual-Color) | 5x2mm Disc (3-Rib Crush) |
| **Cold Snap Showcase** | `CFF-TCG-SHOW` | 🟢 **Production Ready** | Creality K2 SE / PLA+ | M3 Screws & Heat-Sets |
| **Cold Snap Slab** | `CFF-TCG-SLAB` | 🟢 **Production Ready** | Creality K2 SE / PLA+ | 5x2mm Disc (3-Rib Crush) |
| **Cold Snap Rx** | `CFF-TCG-RX` | 🟢 **Production Ready** | Creality K2 SE / PLA+ | 5x2mm Disc (3-Rib Crush) |

---

## 5. Integrating Badges into Project Documentation

Every project `README.md` must display its lifecycle status badge directly beneath the main title:

```markdown
# [Product Name] — [Internal SKU]

![Status: Testing](https://img.shields.io/badge/Status-Testing-orange?style=for-the-badge)
![Lifecycle: Stage 2](https://img.shields.io/badge/Lifecycle-Stage_2-lightgrey?style=for-the-badge)

> [!NOTE]
> **Manufacturing Status: Testing / Tolerance Tuning**
> For lifecycle stage criteria and sign-off requirements, see [Manufacturing Lifecycle Standard](../../../assets/standards/manufacturing-lifecycle.md).
```
