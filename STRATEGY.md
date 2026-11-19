# STRATEGY — BRAINROT WARUNG: Pasar Brainrot

Bounty: roblox-brainrot-01 — "Make the best AI Roblox brainrot game", $1.000,
50 places. Repo: https://github.com/alwanali22/brainrot-warung — entry:
"BRAINROT WARUNG — Pasar Brainrot: 16 brainrots, steal, lock, slap, rebirth,
mutations, 5 events, banjir bandang". Deadline submit: 20 Nov 2026, 21:30 WIB. Status: the
game is built and verified in the VM (Rojo, recorded session); first publish
+ real screenshots + icon/thumbnail + submit wait for the Studio session on
the borrowed PC.

## 1. What the judge ranks on (RULES.txt, in order)

1. **A complete 3D loop the screenshots show**: a character moving through a
   3D world, a brainrot bought or caught, placed on a base, money ticking up
   at its rate, the next tier bought. A game drawn only on a ScreenGui ranks low.
2. **The cast**: absurd named characters, a ladder of rarities or mutations,
   readable name + rarity + money-a-second labels; humour; how many.
3. **Tension & progression**: stealing with a lock or defence, or a hazard;
   rebirths, upgrades, events — each real in the code.
4. **Look & polish**: a built 3D world, a clear interface, effects and
   feedback; the first screenshot (the thumbnail) has to sell the game at a glance.
5. **Structure**: one job per module, a sound client-server split, state in one place.

RULES' golden rule: "What a screenshot shows counts as made when the scripts
or the Place block account for it." — every mechanic must exist in code, not
just in a picture.

## 2. Where the board stands (live, 18 Nov 2026 ~09:00 WIB)

- 22 valid entries. Rank 1: sznbased "Brainrot Bay — Tsunami Steal" 996521.
  Rank 10: musrik "Musrik Brainrot Bazaar - 14 original brainrots, steal,
  lock, tsunami" 994054. Rank 20: cx1twov 989508.
- Rates are packed (rank 1–10 span only ~0.25 points): small differences in
  criteria 1–3 decide everything; there is no room for a half-built mechanic.
- The top 10 is dominated by "Brainrot Bay / Bazaar / Tsunami" clones — the
  same beach/tsunami take on Steal a Brainrot, over and over.
- Our opening: a **different setting and visual identity** (an Indonesian
  night market / warung, not a generic beach) + **16 characters** (more than
  rank 10's 14) + **mutations** (Emas/Berlian/Pelangi, ×2/×3/×5) + **five
  random events with different jobs** (income, spawns, hazard, Secret,
  flood wall) +
  rebirth that re-skins the base.

## 3. The concept: BRAINROT WARUNG — Pasar Brainrot

A 3D night market after dark: an asphalt market street with hanging lights,
rows of warungs (player plots), and one **"Etalase Berjalan"** (conveyor)
parading brainrots past the player. Buy a brainrot off the showcase, put it
on your own warung plot, and it earns $/second. Threat: other players can
**steal** a brainrot off your plot and carry it home; you can **lock your
base for 30 seconds** (auto-lock after a theft, or manual with L, 60 s
cooldown) or **slap** (F) the thief until the catch drops. Progression:
**rebirth "Naik Kelas Warung"** (reset cash + brainrots → permanent
multiplier + a new base skin), plot slot upgrades, and **a random event
every ~90 seconds**.

Why it wins on the judge's criteria:
- K1: the full loop fits one frame — conveyor + buy + plot + $/second
  ticking on the HUD + the next tier on display in the showcase.
- K2: 16 named Italian-brainrot characters, 7 tiers, each model built from
  Parts + a BillboardGui label (name, coloured rarity, $/second) readable
  from far away; rare mutations add a ★ badge and more income.
- K3: steal + 30 s lock + slap + 5 events (Hujan Dodol = 2× income;
  Tung Tung Rush = rare spawns up; Satpol Raid = hazard, get home or lose
  10% cash; Tamu Istimewa = one Secret walks the belt; Banjir Bandang = a
  flood wall sweeps the street, caught off-plot loses 10% cash) + rebirth + slot
  upgrades. All real in server code, not display text.
- K4: a built 3D night world (lamps, carts, trees, market gate), a big
  readable HUD (cash top-centre, away from Roblox's top-left menu buttons),
  and a cover screenshot that frames conveyor + buy + plot + HUD cash.
- K5: one job per module; one state store (server/State); RemoteEvents as
  the only client-server bridge.

## 4. Cast — 16 characters, 7 tiers

| # | Character | Tier | Price | $/second |
|---|-----------|------|-------|----------|
| 1 | Chimpanzini Bananini | Common | $50 | $1 |
| 2 | Lirili Larila | Common | $150 | $3 |
| 3 | Trippi Troppi | Rare | $400 | $7 |
| 4 | Frigo Camelo | Rare | $900 | $15 |
| 5 | Ballerina Cappuccina | Epic | $2.000 | $30 |
| 6 | Cappuccino Assassino | Epic | $3.000 | $45 |
| 7 | Boneca Ambalabu | Epic | $4.500 | $60 |
| 8 | Tralalero Tralala | Legendary | $10.000 | $130 |
| 9 | Brr Brr Patapim | Legendary | $16.000 | $190 |
| 10 | Bombardiro Crocodilo | Legendary | $22.000 | $260 |
| 11 | Giraffa Celeste | Mythic | $50.000 | $550 |
| 12 | Frulli Frulla | Mythic | $75.000 | $800 |
| 13 | La Vaca Saturno Saturnita | Mythic | $110.000 | $1.100 |
| 14 | Pot Hotspot | Brainrot God | $250.000 | $2.400 |
| 15 | Tung Tung Tung Sahur | Secret | $600.000 | $6.000 |
| 16 | Glorbo Fruttodrillo | Secret | $900.000 | $9.000 |

Mutations (shared/Mutations): each conveyor spawn rolls one — Emas ×2 (8%),
Berlian ×3 (3%), Pelangi ×5 (1%). A mutation adds a "★ EMAS / BERLIAN /
PELANGI" badge to the rarity label (in the mutation's colour) and multiplies
that brainrot's $/second.

Each character is built 3D from primitive Parts (body + head + signature
accessory — Tralalero's shark fin, Bombardiro's wings, Ballerina's tutu) +
a BillboardGui with name / rarity / $/second. No unions, meshes or
SurfaceAppearances — the Open Cloud publish requirements hold.

## 5. Mechanics (all real in code)

- **Etalase Berjalan (server/Conveyor)**: a spawn every ~7 s, weighted by
  rarity (Common dominant, Secret very rare); the model walks the 100-stud
  belt and despawns at the end; buy with the ProximityPrompt (E) — checks
  distance, cash, and a free plot slot first.
- **Plots (server/Plots)**: 8 plots, one per player; 4 slots to start,
  +2 slots per upgrade for cash; brainrots on slots earn income; a name
  board marks each warung's owner.
- **Economy (server/Economy + server/State)**: a 1-second tick; income =
  sum of $/second × rebirth multiplier × event multiplier; one state store
  for all players.
- **Stealing (server/Steal)**: stand next to a brainrot on someone else's
  plot to pick it up and carry it home; reaching your own plot makes it
  yours. Lock the base for 30 s automatically after a theft, or manually
  (L, 60 s cooldown). Slap (F): knock the thief back and drop the catch,
  which returns to its owner.
- **Rebirth "Naik Kelas Warung" (server/Rebirth)**: needs cash + at least 3
  brainrots; resets cash + brainrots, adds a permanent +0.5 multiplier,
  and re-skins the base (Kayu → Bata → Neon → Istana Dodol).
- **Random events (server/Events)**: one every ~90 s — Hujan Dodol (2×
  income for 30 s + dodol falling from the sky), Tung Tung Rush (rare
  spawns up for 60 s + 3 rare spawns at once), Satpol Raid (15 s warning,
  then anyone off their plot loses 10% cash), Tamu Istimewa (one Secret
  walks the belt alone), Banjir Bandang (3 s warning, then a flood wall
  sweeps the street over 15 s; anyone it catches off-plot loses 10% cash).
- **Controls (client/Controls)**: movement via ContextActionService (arrow
  keys + WASD, high priority + sink — the default camera scripts take the
  arrow keys on InputBegan, so this binding is the only path, per
  RULES.txt); F = slap, L = lock, R = rebirth. E is left alone so the buy
  ProximityPrompt still receives it.
- **HUD (client/HUD)**: big cash top-centre (far from Roblox's top-left menu
  buttons), $/second, rebirth + multiplier, event banner, Rebirth / Lock /
  Tambah Slot buttons, and the plot's brainrot list.

## 6. Code layout (criterion 5)

```
src/shared/Config.luau        — constants, remote names, event/rebirth tuning
src/shared/BrainrotData.luau  — 16 characters + 7 tiers + spawn weights
src/shared/Mutations.luau     — mutations Emas/Berlian/Pelangi (×2/×3/×5) + roll
src/server/init.server.luau   — wiring: remotes, player join/leave, main loops
src/server/World.luau         — builds the 3D world at runtime (street, lamps, carts)
src/server/State.luau         — the ONE state store for all players
src/server/BrainrotFactory.luau — builds a character model from Parts + label
src/server/Conveyor.luau      — spawn, walk, despawn, buy from the showcase
src/server/Plots.luau         — plots, slots, placement, name boards, upgrades
src/server/Economy.luau       — 1-second income tick, sell
src/server/Steal.luau         — steal, carry, slap, lock
src/server/Rebirth.luau       — requirements, reset, multiplier, base skins
src/server/Events.luau        — random-event scheduler + the 4 events
src/client/HUD.client.luau    — ScreenGui: cash, income, banner, buttons
src/client/Controls.client.luau — ContextActionService: movement + F/L/R
```

## 7. Screenshots (STATUS: placeholder — Studio session)

`screenshots/` still holds the 3 STARTER screenshots (grey boxes) as
placeholders so `makefun check` passes its file gate. They are NOT captures
of this game. The Studio session on the borrowed PC MUST replace them with
3–4 real captures of the game running in Studio (16:9, ≤256 KiB each, the
first = the thumbnail), framing conveyor + buy + plot + HUD cash + the new
world (fence, side stalls, stage, string lights). Do NOT submit before the
screenshots are replaced — finalist review disqualifies screenshots that are
plainly not captures of the submitted game. TOUR.json already covers the new
game's tour (same file names, replaced content in Studio).

## 8. NOT done in this session (Studio session / Wowo)

- First publish to Roblox + Public + play code in the description + fill in
  PLAY.json (place_id + universe_id still 0 — `check` play_link is expected
  to FAIL until then).
- Real screenshots, icon + thumbnail on the Creator Dashboard.
- Submit (waits for Wowo's design review + the Studio session).
