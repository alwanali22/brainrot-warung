# STRATEGY — BRAINROT WARUNG: Pasar Brainrot

Bounty: roblox-brainrot-01 — "Make the best AI Roblox brainrot game", $1.000, 50 tempat.
Repo: https://github.com/alwanali22/brainrot-warung — entry: "BRAINROT WARUNG — Pasar Brainrot".
Deadline submit: 20 Nov 2026, 21:30 WIB. Status: game dibangun di VM (Rojo, recorded);
publish pertama + screenshot asli + icon/thumbnail + submit menunggu sesi Studio di PC pinjaman.

## 1. Kriteria juri (RULES.txt, "The judge" — urutan prioritas)

1. **Loop game 3D lengkap yang terlihat di screenshot**: karakter bergerak di dunia 3D,
   brainrot dibeli/ditangkap, ditaruh di base, uang menetes per detik, tier berikutnya dibeli.
   Game yang hanya digambar di ScreenGui = rank rendah.
2. **Cast brainrot**: karakter absurd bernama, tangga rarity/mutasi, label nama + rarity +
   $/detik yang terbaca; humor; jumlahnya.
3. **Tension & progression**: mencuri dengan lock/defence, atau hazard; rebirth, upgrade,
   event — masing-masing nyata di kode.
4. **Look & polish**: dunia 3D terbangun, interface jelas, efek & feedback; thumbnail
   (screenshot pertama) harus menjual game sekilas.
5. **Struktur**: modul satu tugas satu modul, split client-server yang sehat,
   state di satu tempat.

Aturan emas RULES: "What a screenshot shows counts as made when the scripts or the
Place block account for it." — jadi tiap mekanik HARUS ada di kode, bukan cuma di gambar.

## 2. Posisi board (live, 18 Nov 2026 ~08:10 WIB)

- 22 entry valid. Rank 1: sznbased "Brainrot Bay — Tsunami Steal" 996521.
  Rank 10: quiet-raven-90 "Brainrot Bash" 994054. Rank 20: cx1twov 989508.
- Rate sangat padat (rank 1–20 hanya selisih ~0,7 poin): perbedaan kecil di kriteria
  1–3 memutuskan menang/kalah; tidak ada ruang untuk mekanik setengah jadi.
- Judul top-10 didominasi klon "Brainrot Bay / Bazaar / Tsunami" — hampir semua
  meniru Steal a Brainrot mentah-mentah dengan tema pantai/tsunami yang sama.
- Celah diferensiasi: **setting dan identitas visual yang berbeda** (pasar malam/warung
  Indonesia, bukan pantai generik) + **cast 12 karakter** (lebih banyak dari kebanyakan
  klon) + **tiga event acak yang berbeda fungsi** (income, spawn, hazard) + rebirth
  yang mengubah tampilan base.

## 3. Konsep: BRAINROT WARUNG — Pasar Brainrot

Pasar malam 3D di malam hari: jalan pasar beraspal dengan lampu gantung, deretan warung
(plot pemain), dan satu **"Etalase Berjalan"** (conveyor) yang memparade brainrot lewat
di depan pemain. Pemain membeli brainrot dari etalase, menaruhnya di plot warungnya
sendiri, dan tiap brainrot menghasilkan $/detik. Ancaman: pemain lain bisa **mencuri**
brainrot dari plotmu — bawa pulang ke plotnya; kamu bisa **mengunci base 30 detik**
(setelah dicuri, lock otomatis) atau **menampar (slap)** pencuri sampai brainrot jatuh.
Progression: **rebirth "Naik Kelas Warung"** (reset cash + brainrot → multiplier permanen
+ skin base baru), upgrade slot plot, dan **event acak tiap ~90 detik**.

Kenapa konsep ini menang di kriteria juri:
- K1: loop penuh terlihat — conveyor + beli + plot + $/detik menetes di HUD + tier
  berikutnya terpampang di etalase. Semua elemen loop ada di satu frame screenshot.
- K2: 12 karakter Italian-brainrot bernama, 7 tier rarity, tiap model 3D dibangun dari
  Part + label BillboardGui (nama, rarity berwarna, $/detik) yang terbaca dari jauh.
- K3: steal + lock 30 detik + slap + 3 event (Hujan Dodol = income 2x; Tung Tung Rush =
  spawn langka naik; Satpol Raid = hazard, pulang ke plot atau kehilangan 10% cash) +
  rebirth + upgrade slot. Semua nyata di kode server, bukan teks pajangan.
- K4: dunia 3D malam (lampu, gerobak, pohon, gapura pasar), HUD besar yang terbaca
  saat diperkecil judge (screenshot digabung jadi satu lembar, cover 768x480).
- K5: modul satu tugas satu modul; satu state store (server/State); RemoteEvents
  sebagai satu-satunya jembatan client-server.

## 4. Cast — 12 karakter, 7 tier

| # | Karakter | Tier | Harga | $/detik |
|---|----------|------|-------|---------|
| 1 | Chimpanzini Bananini | Common | $50 | $1 |
| 2 | Lirili Larila | Common | $150 | $3 |
| 3 | Trippi Troppi | Rare | $400 | $7 |
| 4 | Frigo Camelo | Rare | $900 | $15 |
| 5 | Ballerina Cappuccina | Epic | $2.000 | $30 |
| 6 | Boneca Ambalabu | Epic | $4.500 | $60 |
| 7 | Tralalero Tralala | Legendary | $10.000 | $130 |
| 8 | Bombardiro Crocodilo | Legendary | $22.000 | $260 |
| 9 | Giraffa Celeste | Mythic | $50.000 | $550 |
| 10 | La Vaca Saturno Saturnita | Mythic | $110.000 | $1.100 |
| 11 | Pot Hotspot | Brainrot God | $250.000 | $2.400 |
| 12 | Tung Tung Tung Sahur | Secret | $600.000 | $6.000 |

Tiap karakter dibangun 3D dari Part primitif (badan + kepala + aksesori khas, mis.
hiu Tralalero bersirip, buaya Bombardiro bersayap, Ballerina bertutu) + BillboardGui
nama/rarity/$-per-detik. Tidak ada union/mesh/SurfaceAppearance — syarat publish via
Open Cloud terpenuhi.

## 5. Mekanik (semua nyata di kode)

- **Etalase Berjalan (server/Conveyor)**: spawn tiap ~7 detik, bobot rarity
  (Common dominan, Secret sangat langka); model berjalan di conveyor 100 stud lalu
  hilang; beli via ProximityPrompt (tombol E) — cek jarak, cash, slot plot kosong.
- **Plot/Base (server/Plots)**: 8 plot, 1 per pemain; 4 slot awal, upgrade +2 slot
  pakai cash; brainrot di slot menghasilkan income; papan nama pemilik di warung.
- **Ekonomi (server/Economy + server/State)**: tick 1 detik; income = jumlah $/detik
  × multiplier rebirth × multiplier event; satu state store untuk semua pemain.
- **Mencuri (server/Steal)**: sentuh brainrot di plot orang → bawa pulang (model
  mengikuti pencuri); sampai di plot sendiri = milikmu. Lock base 30 detik otomatis
  setelah dicuri + lock manual (tombol L, cooldown 60 detik). Slap (tombol F):
  dorong pencuri + jatuhkan brainrot curian, kembali ke pemilik.
- **Rebirth "Naik Kelas Warung" (server/Rebirth)**: syarat cash + minimal 3 brainrot;
  reset cash + brainrot, multiplier +0,5 permanen, skin base baru per tingkat
  (Kayu → Bata → Neon → Istana Dodol).
- **Event acak (server/Events)**: tiap ~90 detik salah satu dari Hujan Dodol (income
  2x 30 detik + dodol jatuh dari langit), Tung Tung Rush (spawn langka naik 60 detik +
  3 spawn langka langsung), Satpol Raid (peringatan 15 detik, conveyor jeda, pemain di
  luar plot kehilangan 10% cash).
- **Kontrol (client/Controls)**: gerakan pakai ContextActionService (arrow keys + WASD,
  prioritas tinggi + sink — script kamera default Roblox mengambil alih arrow keys
  untuk InputBegan, jadi binding lewat ContextActionService adalah jalurnya, sesuai
  catatan RULES.txt); F = slap, L = lock base, R = menu rebirth. Tombol E dibiarkan
  untuk ProximityPrompt beli (tidak di-sink, supaya prompt tetap menerima E).
- **HUD (client/HUD)**: cash besar di atas-tengah (jauh dari pojok kiri-atas tempat
  tombol menu Roblox), $/detik, rebirth + multiplier, banner event, tombol
  Rebirth / Lock / Tambah Slot, daftar brainrot di plot.

## 6. Struktur kode (kriteria 5)

```
src/shared/Config.luau        — konstanta, nama Remote, tuning event/rebirth
src/shared/BrainrotData.luau  — 12 karakter + 7 tier + bobot spawn
src/server/init.server.luau   — wiring: remotes, player join/leave, loop utama
src/server/World.luau         — bangun dunia 3D saat runtime (jalan, warung, lampu, gerobak)
src/server/State.luau         — SATU state store semua pemain
src/server/BrainrotFactory.luau — bangun model 3D karakter dari Part + label
src/server/Conveyor.luau      — spawn, gerak, despawn, beli dari etalase
src/server/Plots.luau         — plot, slot, penempatan, papan nama, upgrade
src/server/Economy.luau       — tick income 1 detik, jual
src/server/Steal.luau         — curi, bawa, slap, lock
src/server/Rebirth.luau       — syarat, reset, multiplier, skin base
src/server/Events.luau        — scheduler event acak + 3 event
src/client/HUD.client.luau    — ScreenGui: cash, income, banner, tombol
src/client/Controls.client.luau — ContextActionService: gerak + F/L/R
```

## 7. Screenshot (STATUS: placeholder — sesi Studio)

` screenshots/ ` saat ini masih berisi 3 screenshot STARTER (kotak abu-abu) sebagai
placeholder agar `makefun check` lolos gate file. Itu BUKAN screenshot game ini.
Sesi Studio di PC pinjaman (18 Nov) WAJIB menggantinya dengan 3–4 capture asli game
berjalan di Studio (16:9, ≤256 KiB tiap file), dengan screenshot pertama = thumbnail
yang di-upload ke Creator Dashboard. JANGAN submit sebelum screenshot diganti —
finalist review mendiskualifikasi screenshot yang jelas-jelas bukan capture game
yang diserahkan. TOUR.json sudah diperbarui untuk tur game baru (tetap menunjuk
nama file placeholder yang sama, diganti isinya di Studio).

## 8. Yang TIDAK dilakukan di sesi ini (sesi Studio / Wowo)

- Publish pertama ke Roblox + Public + play code di deskripsi + isi PLAY.json
  (place_id/universe_id masih 0 — `check` play_link diharapkan FAIL).
- Screenshot asli, icon + thumbnail di Creator Dashboard.
- Submit (menunggu review desain Wowo + sesi Studio selesai).
