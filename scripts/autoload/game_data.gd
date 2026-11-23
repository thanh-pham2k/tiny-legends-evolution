extends Node

const ELEMENTS := {
	"fire": {"name": "Fire", "color": Color(0.96, 0.36, 0.24), "icon": "res://assets/sprites/icons/elem_fire.png", "beats": "wind"},
	"water": {"name": "Water", "color": Color(0.24, 0.66, 0.98), "icon": "res://assets/sprites/icons/elem_water.png", "beats": "fire"},
	"wind": {"name": "Wind", "color": Color(0.26, 0.84, 0.56), "icon": "res://assets/sprites/icons/elem_wind.png", "beats": "earth"},
	"earth": {"name": "Earth", "color": Color(0.86, 0.64, 0.28), "icon": "res://assets/sprites/icons/elem_earth.png", "beats": "water"},
	"light": {"name": "Light", "color": Color(1.0, 0.86, 0.34), "icon": "res://assets/sprites/icons/elem_light.png", "beats": "dark"},
	"dark": {"name": "Dark", "color": Color(0.68, 0.36, 0.96), "icon": "res://assets/sprites/icons/elem_dark.png", "beats": "light"},
}

const RARITIES := {
	"R": {"color": Color(0.32, 0.66, 0.98), "mult": 1.00, "frame": "res://assets/sprites/cards/card_frame_r.png", "weight": 62.0},
	"SR": {"color": Color(0.74, 0.40, 0.98), "mult": 1.15, "frame": "res://assets/sprites/cards/card_frame_sr.png", "weight": 28.0},
	"SSR": {"color": Color(1.0, 0.78, 0.24), "mult": 1.32, "frame": "res://assets/sprites/cards/card_frame_ssr.png", "weight": 8.5},
	"UR": {"color": Color(1.0, 0.34, 0.46), "mult": 1.50, "frame": "res://assets/sprites/cards/card_frame_ur.png", "weight": 1.5},
}

const ROLE_ICONS := {
	"tank": "res://assets/sprites/ui/class_tank.png",
	"warrior": "res://assets/sprites/ui/class_warrior.png",
	"ranger": "res://assets/sprites/ui/class_ranger.png",
	"mage": "res://assets/sprites/ui/class_mage.png",
	"support": "res://assets/sprites/ui/class_support.png",
	"assassin": "res://assets/sprites/ui/class_assassin.png",
}

const HEROES := {
	"knight": {
		"name": "Little Knight",
		"rarity": "SSR",
		"element": "light",
		"role": "tank",
		"ai_profile": "tank_front",
		"range": "melee",
		"hp": 1450, "atk": 135, "def": 88, "spd": 98,
		"skill_name": "Heroic Wave",
		"skill_desc": "Chém sóng năng lượng gây 210% ATK sát thương và tự tạo khiên 18% Max HP.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_slash.png",
		"vfx": "res://assets/sprites/vfx/vfx_holy_shield.png",
	},
	"paladin": {
		"name": "Paladin",
		"rarity": "SSR",
		"element": "light",
		"role": "tank",
		"ai_profile": "holy_protect",
		"range": "melee",
		"hp": 1620, "atk": 122, "def": 102, "spd": 94,
		"skill_name": "Aegis Bastion",
		"skill_desc": "Tạo lá chắn thánh bảo vệ toàn đội hình (24% Max HP) và hồi nhẹ máu.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_shield.png",
		"vfx": "res://assets/sprites/vfx/vfx_holy_shield.png",
	},
	"berserker": {
		"name": "Berserker",
		"rarity": "SR",
		"element": "fire",
		"role": "warrior",
		"ai_profile": "dps_nearest",
		"range": "melee",
		"hp": 1240, "atk": 178, "def": 64, "spd": 106,
		"skill_name": "Crimson Cleave",
		"skill_desc": "Bổ rìu lửa gây 245% ATK sát thương diện rộng hàng trước.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_axe.png",
		"vfx": "res://assets/sprites/vfx/vfx_fire_slash_double.png",
	},
	"assassin": {
		"name": "Shadow Assassin",
		"rarity": "SR",
		"element": "dark",
		"role": "assassin",
		"ai_profile": "assassin_backline",
		"range": "melee",
		"hp": 960, "atk": 205, "def": 46, "spd": 134,
		"skill_name": "Phantom Cross",
		"skill_desc": "Áp sát hàng sau, chém chí mạng 280% ATK vào mục tiêu ít máu nhất.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_dagger.png",
		"vfx": "res://assets/sprites/vfx/vfx_dark_vortex.png",
	},
	"archer": {
		"name": "Forest Archer",
		"rarity": "R",
		"element": "wind",
		"role": "ranger",
		"ai_profile": "dps_nearest",
		"range": "ranged",
		"hp": 940, "atk": 168, "def": 44, "spd": 120,
		"skill_name": "Emerald Volley",
		"skill_desc": "Bắn mưa tên gió trúng tối đa 3 kẻ địch gây 175% ATK mỗi mục tiêu.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_arrow.png",
		"vfx": "res://assets/sprites/vfx/vfx_wind_tornado.png",
	},
	"sniper": {
		"name": "Golden Sniper",
		"rarity": "SR",
		"element": "earth",
		"role": "ranger",
		"ai_profile": "dps_nearest",
		"range": "ranged",
		"hp": 920, "atk": 196, "def": 45, "spd": 116,
		"skill_name": "Piercing Snipe",
		"skill_desc": "Bắn phát đạn xuyên phá 290% ATK chắc chắn chí mạng vào mục tiêu đầu.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_arrow.png",
		"vfx": "res://assets/sprites/vfx/vfx_fire_explosion.png",
	},
	"mage": {
		"name": "Arcane Mage",
		"rarity": "R",
		"element": "water",
		"role": "mage",
		"ai_profile": "dps_nearest",
		"range": "ranged",
		"hp": 890, "atk": 192, "def": 40, "spd": 108,
		"skill_name": "Glacial Starfall",
		"skill_desc": "Triệu hồi băng tinh rơi xuống toàn bộ kẻ địch gây 165% ATK AoE.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_arcane.png",
		"vfx": "res://assets/sprites/vfx/vfx_ice_nova.png",
	},
	"enchanter": {
		"name": "Star Enchanter",
		"rarity": "SSR",
		"element": "water",
		"role": "mage",
		"ai_profile": "dps_nearest",
		"range": "ranged",
		"hp": 980, "atk": 210, "def": 48, "spd": 114,
		"skill_name": "Astral Circle",
		"skill_desc": "Khai mở vòng phép gây 185% ATK toàn phe địch và tăng tốc đánh đồng minh.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_arcane.png",
		"vfx": "res://assets/sprites/vfx/vfx_arcane_circle.png",
	},
	"priest": {
		"name": "Sakura Priest",
		"rarity": "R",
		"element": "light",
		"role": "support",
		"ai_profile": "healer_lowest",
		"range": "ranged",
		"hp": 1050, "atk": 132, "def": 54, "spd": 112,
		"skill_name": "Sacred Lotus",
		"skill_desc": "Nở hoa sen thánh hồi 260% ATK máu cho toàn đội và ưu tiên đồng minh yếu nhất.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_heal.png",
		"vfx": "res://assets/sprites/vfx/vfx_lotus_bloom.png",
	},
	"druid": {
		"name": "Emerald Druid",
		"rarity": "SR",
		"element": "earth",
		"role": "support",
		"ai_profile": "healer_lowest",
		"range": "ranged",
		"hp": 1140, "atk": 144, "def": 62, "spd": 108,
		"skill_name": "Forest Blessing",
		"skill_desc": "Ban phước rừng xanh hồi 230% ATK máu cho đồng minh yếu nhất + tăng ATK.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_heal.png",
		"vfx": "res://assets/sprites/vfx/vfx_heal_aura.png",
	},
	"samurai": {
		"name": "Blaze Samurai",
		"rarity": "UR",
		"element": "fire",
		"role": "warrior",
		"ai_profile": "dps_nearest",
		"range": "melee",
		"hp": 1340, "atk": 225, "def": 72, "spd": 124,
		"skill_name": "Inferno Iaijutsu",
		"skill_desc": "Liên trảm hỏa kiếm gây 260% ATK AoE lên hàng trước & thiêu đốt.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_slash.png",
		"vfx": "res://assets/sprites/vfx/vfx_fire_slash_single.png",
	},
	"ninja": {
		"name": "Shadow Ninja",
		"rarity": "UR",
		"element": "dark",
		"role": "assassin",
		"ai_profile": "assassin_backline",
		"range": "melee",
		"hp": 1080, "atk": 238, "def": 52, "spd": 142,
		"skill_name": "Wolf Shuriken",
		"skill_desc": "Lao thẳng ra hàng sau địch phóng bão phi tiêu gây 310% ATK sát thương.",
		"skill_icon": "res://assets/sprites/ui/skill_icon_dagger.png",
		"vfx": "res://assets/sprites/vfx/vfx_shadow_wolf.png",
	},
}

const KNIGHT_EVOLUTIONS := {
	"basic": {
		"title": "Little Knight",
		"ai_profile": "tank_front",
		"ai_label": "Tank Frontline — Giữ tuyến trước & tự tạo khiên đơn.",
		"stat_mult": 1.00,
		"skill_name": "Heroic Wave",
		"vfx": "res://assets/sprites/vfx/vfx_holy_shield.png",
	},
	"advance": {
		"title": "Iron Knight",
		"ai_profile": "tank_front",
		"ai_label": "Iron Vanguard — Chỉ số tăng +25%, chống chịu tuyến trước.",
		"stat_mult": 1.25,
		"skill_name": "Iron Slash",
		"vfx": "res://assets/sprites/vfx/vfx_lightning_pillar.png",
	},
	"fire": {
		"title": "Fire Knight",
		"ai_profile": "fire_aoe",
		"ai_label": "AI Mới: AoE Damage — Chủ động lao vào giữa đội hình địch tung Đại Hỏa Trảm AoE!",
		"stat_mult": 1.55,
		"skill_name": "Inferno AoE Slam",
		"vfx": "res://assets/sprites/vfx/vfx_fire_explosion.png",
	},
	"holy": {
		"title": "Holy Guardian",
		"ai_profile": "holy_protect",
		"ai_label": "AI Mới: Protect Allies — Tự động buff khiên & hồi máu bảo vệ toàn đồng minh!",
		"stat_mult": 1.55,
		"skill_name": "Seraphic Bastion",
		"vfx": "res://assets/sprites/vfx/vfx_holy_shield.png",
	},
}

const ENEMIES := {
	"goblin": {"name": "Goblin Raider", "element": "earth", "role": "warrior", "ai_profile": "dps_nearest", "range": "melee", "hp": 620, "atk": 78, "def": 30, "spd": 102, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_fire_slash_single.png"},
	"skeleton": {"name": "Bone Soldier", "element": "dark", "role": "warrior", "ai_profile": "dps_nearest", "range": "melee", "hp": 680, "atk": 84, "def": 36, "spd": 96, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_dark_vortex.png"},
	"wolf": {"name": "Dire Wolf", "element": "wind", "role": "assassin", "ai_profile": "assassin_backline", "range": "melee", "hp": 540, "atk": 102, "def": 24, "spd": 130, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_shadow_wolf.png"},
	"boar": {"name": "Wild Boar", "element": "earth", "role": "tank", "ai_profile": "tank_front", "range": "melee", "hp": 960, "atk": 76, "def": 56, "spd": 86, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_fire_explosion.png"},
	"dark_knight": {"name": "Dark Footman", "element": "dark", "role": "tank", "ai_profile": "tank_front", "range": "melee", "hp": 1150, "atk": 96, "def": 68, "spd": 88, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_dark_vortex.png"},
	"dark_mage": {"name": "Cultist Mage", "element": "dark", "role": "mage", "ai_profile": "dps_nearest", "range": "ranged", "hp": 640, "atk": 118, "def": 28, "spd": 104, "is_boss": false, "vfx": "res://assets/sprites/vfx/vfx_arcane_circle.png"},
	"boss_golem": {"name": "Stone Golem", "element": "earth", "role": "tank", "ai_profile": "fire_aoe", "range": "melee", "hp": 3800, "atk": 165, "def": 95, "spd": 78, "is_boss": true, "vfx": "res://assets/sprites/vfx/vfx_fire_explosion.png"},
	"boss_ice_dragon": {"name": "Frost Dragon", "element": "water", "role": "mage", "ai_profile": "fire_aoe", "range": "ranged", "hp": 5400, "atk": 205, "def": 105, "spd": 96, "is_boss": true, "vfx": "res://assets/sprites/vfx/vfx_ice_nova.png"},
	"boss_demon_lord": {"name": "Demon Lord", "element": "fire", "role": "warrior", "ai_profile": "fire_aoe", "range": "melee", "hp": 7600, "atk": 248, "def": 120, "spd": 105, "is_boss": true, "vfx": "res://assets/sprites/vfx/vfx_fire_explosion.png"},
}

const CHAPTER_BACKGROUNDS := [
	"res://assets/sprites/backgrounds/bg_plains_kingdom.png",
	"res://assets/sprites/backgrounds/bg_desert_oasis.png",
	"res://assets/sprites/backgrounds/bg_frozen_tundra.png",
	"res://assets/sprites/backgrounds/bg_demon_castle.png",
]

const CHAPTER_BIOMES := ["plains", "desert", "tundra", "demon"]

# Map pin normalized positions following the winding trail in bg_campaign_map.png
const STAGE_MAP_POSITIONS := [
	Vector2(0.18, 0.80), Vector2(0.26, 0.72), Vector2(0.38, 0.68), Vector2(0.42, 0.60), Vector2(0.54, 0.56),
	Vector2(0.76, 0.76), Vector2(0.84, 0.66), Vector2(0.70, 0.58), Vector2(0.58, 0.48), Vector2(0.53, 0.42),
	Vector2(0.45, 0.34), Vector2(0.32, 0.32), Vector2(0.24, 0.25), Vector2(0.34, 0.19), Vector2(0.50, 0.22),
	Vector2(0.68, 0.33), Vector2(0.78, 0.26), Vector2(0.72, 0.18), Vector2(0.60, 0.13), Vector2(0.52, 0.09),
]


func get_hero_stats(hero_id: String, level: int, stars: int, evo_tier: String = "basic") -> Dictionary:
	var base: Dictionary = HEROES.get(hero_id, HEROES["knight"])
	var rarity_mult: float = float(RARITIES[base["rarity"]]["mult"])
	var lv_mult: float = 1.0 + float(maxi(0, level - 1)) * 0.065
	var star_mult: float = 1.0 + float(maxi(0, stars - 1)) * 0.22
	var evo_mult: float = 1.0
	if hero_id == "knight" and KNIGHT_EVOLUTIONS.has(evo_tier):
		evo_mult = float(KNIGHT_EVOLUTIONS[evo_tier]["stat_mult"])
	var total_mult := rarity_mult * lv_mult * star_mult * evo_mult
	var hp := int(round(float(base["hp"]) * total_mult))
	var atk := int(round(float(base["atk"]) * total_mult))
	var df := int(round(float(base["def"]) * total_mult))
	var spd := int(base["spd"])
	var power := int(round(float(hp) * 0.45 + float(atk) * 3.8 + float(df) * 2.2 + float(spd) * 1.5))
	return {"hp": hp, "atk": atk, "def": df, "spd": spd, "power": power}


func get_hero_display_name(hero_id: String, evo_tier: String = "basic") -> String:
	if hero_id == "knight" and KNIGHT_EVOLUTIONS.has(evo_tier):
		return String(KNIGHT_EVOLUTIONS[evo_tier]["title"])
	return String(HEROES.get(hero_id, {}).get("name", hero_id.capitalize()))


func get_hero_ai_profile(hero_id: String, evo_tier: String = "basic") -> String:
	if hero_id == "knight" and KNIGHT_EVOLUTIONS.has(evo_tier):
		return String(KNIGHT_EVOLUTIONS[evo_tier]["ai_profile"])
	return String(HEROES.get(hero_id, {}).get("ai_profile", "dps_nearest"))


func get_hero_skill_info(hero_id: String, evo_tier: String = "basic") -> Dictionary:
	var base: Dictionary = HEROES.get(hero_id, HEROES["knight"])
	if hero_id == "knight" and KNIGHT_EVOLUTIONS.has(evo_tier):
		var evo: Dictionary = KNIGHT_EVOLUTIONS[evo_tier]
		return {
			"name": evo["skill_name"],
			"desc": evo["ai_label"],
			"icon": base["skill_icon"],
			"vfx": evo["vfx"],
		}
	return {
		"name": base["skill_name"],
		"desc": base["skill_desc"],
		"icon": base["skill_icon"],
		"vfx": base["vfx"],
	}


func get_hero_portrait_path(hero_id: String, evo_tier: String = "basic") -> String:
	if hero_id == "knight":
		match evo_tier:
			"advance":
				return "res://assets/sprites/heroes/knight_evo_advance.png"
			"fire":
				return "res://assets/sprites/heroes/knight_evo_fire.png"
			"holy":
				return "res://assets/sprites/heroes/knight_evo_holy.png"
	return "res://assets/sprites/heroes/%s_portrait.png" % hero_id


func get_hero_standee_path(hero_id: String) -> String:
	var p := "res://assets/sprites/heroes/%s_standee.png" % hero_id
	if ResourceLoader.exists(p):
		return p
	return get_hero_portrait_path(hero_id, "basic")


func get_showcase_bg_path(element: String) -> String:
	var el := element if element in ["fire", "water", "wind", "earth", "light", "dark"] else "light"
	return "res://assets/sprites/backgrounds/bg_showcase_%s.png" % el


func get_showcase_pedestal_path(element: String) -> String:
	match element:
		"fire":
			return "res://assets/sprites/ui/showcase_pedestal_fire.png"
		"water", "wind":
			return "res://assets/sprites/ui/showcase_pedestal_water.png"
		"dark":
			return "res://assets/sprites/ui/showcase_pedestal_dark.png"
		_:
			return "res://assets/sprites/ui/showcase_pedestal_light.png"


# Zero-based contact cels selected from the visible swing or release in each sheet.
const CONTACT_CELS := {
	"knight": [2, 2], "knight_fire": [3, 3], "knight_holy": [2, 3],
	"paladin": [2, 3], "berserker": [3, 3], "assassin": [2, 3],
	"archer": [3, 2], "sniper": [2, 3], "mage": [3, 3],
	"enchanter": [3, 3], "priest": [3, 3], "druid": [3, 3],
	"samurai": [3, 3], "ninja": [2, 3], "goblin": [2, 2],
	"skeleton": [3, 3], "wolf": [3, 3], "boar": [3, 3],
	"dark_knight": [3, 3], "dark_mage": [3, 3], "boss_golem": [2, 3],
	"boss_ice_dragon": [3, 3], "boss_demon_lord": [2, 3],
}


func _animation(prefix: String, state: String, cols: int, rows: int, fps: float, loop: bool) -> Dictionary:
	return {
		"texture": load("%s_%s.png" % [prefix, state]),
		"hframes": cols, "vframes": rows, "frames": cols * rows,
		"fps": fps, "loop": loop,
	}


func get_hero_anim_map(hero_id: String, evo_tier: String = "basic") -> Dictionary:
	if not HEROES.has(hero_id):
		hero_id = "knight"
	var actor := "knight_" + evo_tier if hero_id == "knight" and evo_tier in ["fire", "holy"] else hero_id
	var prefix := "res://assets/sprites/heroes/" + actor
	var idle := _animation(prefix, "idle", 2, 2, 3.0, true)
	idle["ping_pong"] = true
	var attack := _animation(prefix, "skill" if actor != hero_id else "attack", 3, 2, 13.0, false)
	var skill := _animation(prefix, "skill", 3, 2, 11.0, false)
	var contacts: Array = CONTACT_CELS[actor]
	attack["contact"] = contacts[0]
	skill["contact"] = contacts[1]
	var anims := {"idle": idle, "run": idle, "attack": attack, "skill": skill}
	if actor == "knight":
		anims["run"] = _animation(prefix, "run", 3, 2, 9.5, true)
		anims["hit"] = _animation(prefix, "hit", 3, 1, 12.0, false)
		anims["death"] = _animation(prefix, "death", 2, 2, 9.0, false)
	return anims


func get_enemy_anim_map(enemy_id: String) -> Dictionary:
	if not ENEMIES.has(enemy_id):
		enemy_id = "goblin"
	var boss := bool(ENEMIES[enemy_id].get("is_boss", false))
	var prefix := "res://assets/sprites/%s/%s" % ["bosses" if boss else "enemies", enemy_id]
	var attack := _animation(prefix, "attack", 3, 2, 13.0, false)
	var skill := _animation(prefix, "skill", 3, 2, 10.0, false) if boss else attack.duplicate()
	var contacts: Array = CONTACT_CELS[enemy_id]
	attack["contact"] = contacts[0]
	skill["contact"] = contacts[1]
	# Some mobs only have a swing sheet. Its standing opener shares the
	# combat pivot/scale, and the pose drives a procedural locomotion fallback.
	var idle := attack.duplicate()
	idle["idle_frames"] = 1
	if boss:
		idle = _animation(prefix, "idle", 2, 2, 2.8, true)
		idle["ping_pong"] = true
	var anims := {"idle": idle, "run": idle, "attack": attack, "skill": skill}
	if enemy_id == "goblin":
		anims["run"] = _animation(prefix, "run", 3, 2, 9.5, true)
		anims["death"] = _animation(prefix, "death", 2, 2, 9.0, false)
	return anims


func get_synergy_bonus(team_ids: Array) -> Dictionary:
	var counts: Dictionary = {}
	var valid_count := 0
	for hid in team_ids:
		if HEROES.has(hid):
			valid_count += 1
			var el := String(HEROES[hid]["element"])
			counts[el] = int(counts.get(el, 0)) + 1

	var max_same := 0
	var dominant_el := ""
	for el in counts:
		if int(counts[el]) > max_same:
			max_same = int(counts[el])
			dominant_el = String(el)

	if max_same >= 5:
		return {"atk_bonus": 0.35, "hp_bonus": 0.35, "label": "5x %s (+35%% ATK/HP)" % dominant_el.capitalize()}
	if max_same >= 3:
		return {"atk_bonus": 0.20, "hp_bonus": 0.20, "label": "3x %s (+20%% ATK/HP)" % dominant_el.capitalize()}
	if valid_count == 5 and counts.size() == 5:
		return {"atk_bonus": 0.15, "hp_bonus": 0.15, "label": "5-Element Harmony (+15%% All)"}
	if max_same >= 2:
		return {"atk_bonus": 0.10, "hp_bonus": 0.10, "label": "2x %s (+10%% ATK/HP)" % dominant_el.capitalize()}
	return {"atk_bonus": 0.0, "hp_bonus": 0.0, "label": "No Synergy"}


func get_element_multiplier(attacker_el: String, defender_el: String) -> float:
	if ELEMENTS.has(attacker_el) and String(ELEMENTS[attacker_el]["beats"]) == defender_el:
		return 1.25
	return 1.0


func get_stage_data(stage_num: int) -> Dictionary:
	var s := clampi(stage_num, 1, 20)
	var chapter := (s - 1) / 5
	var scale_mult := 0.82 + float(s - 1) * 0.16
	var is_boss := (s % 5 == 0)
	var boss_id := ""
	var squad: Array = []

	match chapter:
		0:
			squad = ["goblin", "goblin", "wolf", "goblin", "skeleton"]
			if is_boss:
				boss_id = "boss_golem"
				squad = ["goblin", "boar", "boss_golem", "wolf", "skeleton"]
		1:
			squad = ["boar", "skeleton", "wolf", "dark_mage", "goblin"]
			if is_boss:
				boss_id = "boss_golem"
				squad = ["boar", "dark_knight", "boss_golem", "dark_mage", "wolf"]
		2:
			squad = ["dark_knight", "boar", "skeleton", "dark_mage", "wolf"]
			if is_boss:
				boss_id = "boss_ice_dragon"
				squad = ["dark_knight", "boar", "boss_ice_dragon", "dark_mage", "dark_mage"]
		_:
			squad = ["dark_knight", "dark_knight", "wolf", "dark_mage", "dark_mage"]
			if is_boss:
				boss_id = "boss_demon_lord"
				squad = ["dark_knight", "dark_knight", "boss_demon_lord", "dark_mage", "wolf"]

	# Early stages have fewer mobs so stage 1-3 ease the player in smoothly
	var count := 3 if s == 1 else (4 if s <= 3 else 5)
	squad = squad.slice(0, count)

	return {
		"stage": s,
		"chapter": chapter + 1,
		"name": "Stage %d-%d%s" % [chapter + 1, ((s - 1) % 5) + 1, " [BOSS]" if is_boss else ""],
		"is_boss": is_boss,
		"boss_id": boss_id,
		"bg_path": CHAPTER_BACKGROUNDS[chapter],
		"biome": CHAPTER_BIOMES[chapter],
		"enemies": squad,
		"stat_scale": scale_mult,
		"reward_gold": 450 + s * 140 + (600 if is_boss else 0),
		"reward_exp": 320 + s * 100 + (450 if is_boss else 0),
		"reward_gems": 120 if is_boss else 45,
		"map_pos": STAGE_MAP_POSITIONS[s - 1],
	}
