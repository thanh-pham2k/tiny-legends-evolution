# AGENTS.md — Tiny Legends: Evolution (Godot 4.7.2)

> **Project References:** [docs/GDD.md](docs/GDD.md) · [docs/ASSET_SPEC.md](docs/ASSET_SPEC.md) · [docs/asset_prompts/00_MASTER_CHECKLIST.md](docs/asset_prompts/00_MASTER_CHECKLIST.md)

## Game Design & UI/UX Reference Policy

**Principle: Research first. Reuse proven patterns. Do not reinvent the wheel.**

Before designing, implementing, or modifying any game mechanic, UI, UX, animation, or progression system:

1. Research at least 2–3 relevant, successful games.
2. Study their actual mechanics, layouts, interactions, and player feedback (not just screenshots — verify real rules, costs, pools, and UX flows).
3. Select the most suitable proven approach for Tiny Legends: Evolution.
4. Adapt it to the existing Japanese anime-fantasy chibi style and Godot architecture.
5. Prioritize simplicity, consistency, usability, and MVP scope.
6. Do not invent new systems when established solutions already work.
7. Never blindly copy copyrighted artwork, assets, or entire UI designs.
8. Implement, run in Godot, test, capture screenshots, and refine until polished.

### Primary MVP Pillars

- **Gameplay & Progression:** AFK Arena
- **Heroes & Gacha:** Epic Seven
- **Town Hub:** Cookie Run: Kingdom
- **Top 5 Priority References for MVP:** AFK Arena, Epic Seven, Honkai: Star Rail, Cookie Run: Kingdom, Guardian Tales.

### Reference Games (20)

1. **AFK Arena** — Idle rewards, progression, hero upgrades.
2. **AFK Journey** — World hub, exploration, fantasy UI.
3. **Epic Seven** — Gacha, hero collection, skills, equipment.
4. **Genshin Impact** — Gacha banners, pity, character showcase.
5. **Honkai: Star Rail** — Summon UX, character presentation.
6. **Summoners War** — Summoning, evolution, elements.
7. **Cookie Run: Kingdom** — Interactive town, buildings, navigation.
8. **Guardian Tales** — Town hub, exploration, interactions.
9. **Mobile Legends: Adventure** — Idle systems, team progression.
10. **RAID: Shadow Legends** — Hero collection, rarity, equipment.
11. **Arknights** — Team composition, roles, tactical UI.
12. **Fire Emblem Heroes** — Summoning, character management.
13. **Granblue Fantasy** — Progression, summons, events.
14. **Blue Archive** — Character upgrades, skills, UI.
15. **Goddess of Victory: NIKKE** — Character showcase, Gacha UX.
16. **Clash of Clans** — Scrollable maps, buildings, camera.
17. **Pokémon Masters EX** — Team building, progression.
18. **Seven Knights Idle Adventure** — Idle progression, rewards.
19. **Eversoul** — Idle rewards, hero development.
20. **Brown Dust 2** — Character UI, combat, skill presentation.

### Reference Selection

- **Gacha:** Epic Seven, Honkai: Star Rail, Genshin Impact.
- **Heroes & Evolution:** AFK Arena, Epic Seven, Eversoul.
- **Idle Rewards:** AFK Arena, AFK Journey, Mobile Legends: Adventure.
- **World Map / Town Hub:** Cookie Run: Kingdom, Guardian Tales, Clash of Clans.
- **Battle / Team Building:** Arknights, Summoners War, Pokémon Masters EX.
- **Character Art / Animation:** Epic Seven, Brown Dust 2, NIKKE.

### Mandatory Workflow

**Research → Compare → Select → Adapt → Implement → Test → Screenshot → Refine**

For every substantial change, briefly report:

- Reference games and selected design patterns.
- Why the chosen approach fits the MVP.
- Implemented changes and verification results.

**Rule:** Prefer established, player-tested solutions over unnecessary invention. Preserve existing working functionality. Never add complexity solely to imitate a larger game.
