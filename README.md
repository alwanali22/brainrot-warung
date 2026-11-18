# BRAINROT WARUNG — Pasar Brainrot

Entry for make.fun's "Make the best AI Roblox brainrot game" bounty (roblox-brainrot-01):
a 3D night-market brainrot game built as a Rojo project in Roblox's 3D world.

- **The game**: buy named brainrot characters off the moving "Etalase Berjalan"
  conveyor, place them on your warung plot, and earn money every second. Steal
  brainrots from other players' plots (base lock + slap to defend), rebirth
  ("Naik Kelas Warung") for a permanent income multiplier and a new base skin,
  and survive random events: Hujan Dodol (income x2), Tung Tung Rush (rare
  spawns flood the conveyor), Satpol Raid (get home or lose 10% of your cash).
- **The cast**: 12 Italian-brainrot characters (Tralalero Tralala, Bombardiro
  Crocodilo, Ballerina Cappuccina, Tung Tung Tung Sahur, ...) across 7 rarity
  tiers, each built in 3D from primitive Parts with a readable name/rarity/$-per-second label.
- `main.ts` (Node 22, standard library only) hands the game in: it copies `game.rbxl`,
  `src/`, `screenshots/` and `PLAY.json` to `/output`, leaving out every name that
  starts with a dot (such as `.gitkeep` or `.DS_Store`, which fail an entry), and writes
  `/output/dossier.json` with `vendor/makefun-roblox.ts`, the kit's copy, unchanged.
- `game.rbxl` is the place Rojo builds from `src/` and `default.project.json`; see
  `STRATEGY.md` for the judge criteria, the live board, and the design.
- `src/` holds the Luau: `shared/` (Config, BrainrotData), `server/` (one module per
  job: World, State, BrainrotFactory, Conveyor, Plots, Economy, Steal, Rebirth,
  Events), `client/` (HUD, Controls via ContextActionService).
- **Status — screenshots are PLACEHOLDERS**: `screenshots/` still holds the kit
  starter's three grey-square captures. They will be replaced in the Studio session
  on the borrowed Windows PC with real captures of this game running in Studio
  (16:9, ≤256 KiB each), the first of which becomes the game's Roblox thumbnail.
  Do NOT submit before they are replaced.
- **Status — PLAY.json**: still names place 0. The first publish from Studio fills
  in the real `place_id` / `universe_id`, the play code goes in the experience
  description, and the experience is set Public.

Run it as the grader does, writing `out/` in place of `/output`:

    mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

Build the place first:

    ~/workspace/makefun/roblox-brainrot-01/tools/rojo build default.project.json --output game.rbxl

The rules are on the bounty's page (/bounty/roblox-brainrot-01) and in the kit's RULES.txt,
which gives every command in order (Before you submit, then Enter).
