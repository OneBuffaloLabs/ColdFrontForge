# The SnapFit Collection: Professional Sports Logos

High-tolerance, multi-part 3D prints designed for a clean friction fit. No glue, just precise plastic tolerances.

This collection uses OpenSCAD to convert vector artwork into multi-piece, snap-together physical prints. By tuning built-in clearances and accounting for filament shrinkage, each piece locks cleanly together like a puzzle without needing an AMS or mid-print pauses.

## 🧬 Universal Print Specs

These baseline rules apply to every model across this collection:

- **Clearance:** Designed with standard offsets between `0.05 mm` and `0.15 mm`.
- **Layer Height:** Fixed at `0.20 mm`.
- **Wall Generator:** **Arachne** is required to preserve small details like sharp tips and thin borders.
- **Top Surface:** `Concentric` (follows the shape of the logo) or `Monotonic Line`.
- **Elephant Foot Compensation:** Set between `0.15 mm` and `0.20 mm` so first-layer flare doesn't bind the pockets.

## 🛠 Assembly Tips

- **Flat Surface:** Assemble on a flat, solid tabletop.
- **Cooling:** Let parts cool completely before assembly. Warm plastic is flexible and will distort instead of snapping.
- **The Fit:** Press straight down with the flat of your thumb until the piece clicks flush.
- **Glue Backup:** If your printer runs loose on tolerances, a tiny drop of CA glue inside the pocket will lock it permanently.

## 🧪 Calibration & Testing

Before printing a complete logo, print the [Clearance Tester](./clearance-tester/) to dial in your extrusion and slicer settings.

1. **Base:** Features three test slots sized at `0.05 mm`, `0.10 mm`, and `0.15 mm`.
2. **Insert:** Standard test block to check insertion force.
3. **Verify:** Slice both with the **Arachne** engine to match the actual production profiles.

---

## 🏈 NFL Status

**Key:** ✅ Live | ⏳ In Progress | 📅 Planned

### American Football Conference (AFC)

**AFC East**

- [x] ✅ **[Buffalo Bills](./bills/)**
- [ ] 📅 Miami Dolphins
- [ ] 📅 New England Patriots
- [ ] 📅 New York Jets

**AFC North**

- [ ] 📅 Baltimore Ravens
- [ ] 📅 Cincinnati Bengals
- [ ] 📅 Cleveland Browns
- [ ] 📅 Pittsburgh Steelers

**AFC South**

- [ ] 📅 Houston Texans
- [ ] 📅 Indianapolis Colts
- [ ] 📅 Jacksonville Jaguars
- [ ] 📅 Tennessee Titans

**AFC West**

- [ ] 📅 Denver Broncos
- [ ] 📅 Kansas City Chiefs
- [ ] 📅 Las Vegas Raiders
- [ ] 📅 Los Angeles Chargers

### National Football Conference (NFC)

**NFC East**

- [ ] 📅 Dallas Cowboys
- [ ] 📅 New York Giants
- [ ] 📅 Philadelphia Eagles
- [ ] 📅 Washington Commanders

**NFC North**

- [ ] 📅 Chicago Bears
- [ ] ⏳ Detroit Lions
- [ ] 📅 Green Bay Packers
- [ ] 📅 Minnesota Vikings

**NFC South**

- [ ] 📅 Atlanta Falcons
- [ ] 📅 Carolina Panthers
- [ ] 📅 New Orleans Saints
- [ ] 📅 Tampa Bay Buccaneers

**NFC West**

- [ ] 📅 Arizona Cardinals
- [ ] 📅 Los Angeles Rams
- [ ] 📅 San Francisco 49ers
- [ ] 📅 Seattle Seahawks

---

### Legal Disclaimer

_All designs in this directory are fan art for personal, non-commercial use. They are not affiliated with, authorized by, or endorsed by the National Football League (NFL) or its teams. All team names and trademarks belong to their respective owners._

_See the root [LEGAL.md](../../../LEGAL.md) for full licensing details._
