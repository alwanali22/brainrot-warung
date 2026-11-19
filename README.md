# BRAINROT WARUNG — Pasar Brainrot

A 3D Roblox brainrot game for make.fun's `roblox-brainrot-01` bounty
("Make the best AI Roblox brainrot game", $1.000, 50 places).

**The game:** a night market in 3D. Brainrots parade down the "Etalase
Berjalan" (walking showcase / conveyor) in front of the player. Buy one with
E, park it on your warung plot, and it earns $/second. Other players can
steal from your plot — carry the catch home, or slap the thief (F) to knock
it loose. Lock your base (L), upgrade plot slots, and rebirth ("Naik Kelas
Warung") for a permanent income multiplier and a new base skin.

- **16 brainrots, 7 tiers** (Common → Secret), each a 3D model built from
  Parts with a readable name / rarity / $/second label.
- **Mutations:** every spawn can roll Emas ×2 (8%), Berlian ×3 (3%) or
  Pelangi ×5 (1%) — a ★ badge on the label and multiplied income.
- **5 random events** (~every 90 s): Hujan Dodol (2× income), Tung Tung Rush
  (rare spawns flood the belt), Satpol Raid (get home or lose 10% cash),
  Tamu Istimewa (a lone Secret walks the belt), Banjir Bandang (a flood
  wall sweeps the street — caught off-plot, lose 10% cash).
- **Steal + lock + slap, rebirth, slot upgrades** — all real in the code.
- **Buku Warung:** a collection book in the HUD — owned / 16 and seen / 16,
  tracked on the server (belt spawns count as seen, buys and steals count
  as owned).
- **Effects:** dodol rain particles during Hujan Dodol, a gold burst + slap
  sound on a successful slap, gold confetti + chime on rebirth, and a
  tweened event banner.
- **World:** night market street, fence, side stalls, stage, string lights,
  gate, lamps, carts, trees, dodol crates — 96 Place instances.

## Build

```sh
rojo build default.project.json --output game.rbxl
MAKEFUN_OUTPUT_DIR=out node main.ts
```

## Status

- Game built + verified in the VM (Rojo, Luau, `makefun check`).
- Still waiting on the Studio session (borrowed PC): first publish as a
  Public experience, play code `makefun-jade-foghorn-toboggan` in the
  description, fill in `PLAY.json`, replace the 3 placeholder screenshots
  with real Studio captures, upload icon + thumbnail — then submit.
