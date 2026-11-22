extends Node

signal resources_changed
signal roster_changed
signal settings_changed

const PITY_THRESHOLD := 30
const IDLE_CAP_SECONDS := 43200  # 12 hours max accumulation

var save_path: String = "user://save.json"

var gold: int = 15000
var exp_pool: int = 8000
var gems: int = 3200
var tickets: int = 10
var pity_counter: int = 0
var max_stage_unlocked: int = 1
var selected_stage: int = 1
var last_idle_claim_unix: int = 0
var fps_cap: int = 60

# hero_id -> { "level": int, "stars": int, "shards": int, "evo": String }
var owned_heroes: Dictionary = {}
# 5 slots: index 0..1 Frontline, 2..4 Backline
var team_slots: Array[String] = ["knight", "berserker", "archer", "mage", "priest"]


func _ready() -> void:
	load_game()
	apply_fps_cap()


func reset_to_defaults(now_unix: int = -1) -> void:
	var ts := now_unix if now_unix >= 0 else int(Time.get_unix_time_from_system())
	gold = 15000
	exp_pool = 8000
	gems = 3200
	tickets = 10
	pity_counter = 0
	max_stage_unlocked = 1
	selected_stage = 1
	last_idle_claim_unix = ts - 3600  # Start with 1 hour of idle rewards ready to test!
	fps_cap = 60
	owned_heroes = {
		"knight": {"level": 1, "stars": 1, "shards": 15, "evo": "basic"},
		"berserker": {"level": 1, "stars": 1, "shards": 5, "evo": "basic"},
		"archer": {"level": 1, "stars": 1, "shards": 5, "evo": "basic"},
		"mage": {"level": 1, "stars": 1, "shards": 5, "evo": "basic"},
		"priest": {"level": 1, "stars": 1, "shards": 5, "evo": "basic"},
	}
	team_slots = ["knight", "berserker", "archer", "mage", "priest"]


func save_game() -> void:
	var payload := {
		"gold": gold,
		"exp_pool": exp_pool,
		"gems": gems,
		"tickets": tickets,
		"pity_counter": pity_counter,
		"max_stage_unlocked": max_stage_unlocked,
		"selected_stage": selected_stage,
		"last_idle_claim_unix": last_idle_claim_unix,
		"fps_cap": fps_cap,
		"owned_heroes": owned_heroes,
		"team_slots": team_slots,
	}
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify(payload, "\t"))
		f.close()


func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		reset_to_defaults()
		save_game()
		return
	var f := FileAccess.open(save_path, FileAccess.READ)
	if f == null:
		reset_to_defaults()
		return
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		reset_to_defaults()
		return

	gold = int(parsed.get("gold", 15000))
	exp_pool = int(parsed.get("exp_pool", 8000))
	gems = int(parsed.get("gems", 3200))
	tickets = int(parsed.get("tickets", 10))
	pity_counter = int(parsed.get("pity_counter", 0))
	max_stage_unlocked = clampi(int(parsed.get("max_stage_unlocked", 1)), 1, 20)
	selected_stage = clampi(int(parsed.get("selected_stage", 1)), 1, max_stage_unlocked)
	last_idle_claim_unix = int(parsed.get("last_idle_claim_unix", int(Time.get_unix_time_from_system())))
	fps_cap = 30 if int(parsed.get("fps_cap", 60)) == 30 else 60
	owned_heroes = parsed.get("owned_heroes", {})
	if owned_heroes.is_empty():
		reset_to_defaults()
		return

	var saved_team: Array = parsed.get("team_slots", [])
	team_slots.clear()
	for s in saved_team:
		if owned_heroes.has(String(s)):
			team_slots.append(String(s))
	while team_slots.size() < 5:
		team_slots.append("")


func set_fps_cap(fps: int) -> void:
	fps_cap = 30 if fps == 30 else 60
	apply_fps_cap()
	save_game()
	settings_changed.emit()


func apply_fps_cap() -> void:
	Engine.max_fps = fps_cap


func get_hero_record(hero_id: String) -> Dictionary:
	return owned_heroes.get(hero_id, {})


func get_team_power() -> int:
	var total := 0
	var syn := GameData.get_synergy_bonus(team_slots)
	for hid in team_slots:
		if owned_heroes.has(hid):
			var rec: Dictionary = owned_heroes[hid]
			var st := GameData.get_hero_stats(hid, int(rec["level"]), int(rec["stars"]), String(rec["evo"]))
			total += int(st["power"])
	return int(round(float(total) * (1.0 + float(syn["atk_bonus"]) * 0.6)))


func set_team_slot(slot_idx: int, hero_id: String) -> void:
	if slot_idx < 0 or slot_idx >= 5 or not owned_heroes.has(hero_id):
		return
	var existing_idx := team_slots.find(hero_id)
	if existing_idx != -1 and existing_idx != slot_idx:
		var prev := team_slots[slot_idx]
		team_slots[slot_idx] = hero_id
		team_slots[existing_idx] = prev
	else:
		team_slots[slot_idx] = hero_id
	save_game()
	roster_changed.emit()


func get_level_cost(cur_level: int) -> Dictionary:
	return {
		"gold": 180 + cur_level * 95,
		"exp": 120 + cur_level * 70,
	}


func level_up_hero(hero_id: String) -> bool:
	if not owned_heroes.has(hero_id):
		return false
	var rec: Dictionary = owned_heroes[hero_id]
	var lv := int(rec["level"])
	if lv >= 50:
		return false
	var cost := get_level_cost(lv)
	if gold < int(cost["gold"]) or exp_pool < int(cost["exp"]):
		return false
	gold -= int(cost["gold"])
	exp_pool -= int(cost["exp"])
	rec["level"] = lv + 1
	owned_heroes[hero_id] = rec
	save_game()
	resources_changed.emit()
	roster_changed.emit()
	return true


func get_star_shard_cost(cur_stars: int) -> int:
	return 10 if cur_stars == 1 else (20 if cur_stars == 2 else 999)


func star_up_hero(hero_id: String) -> bool:
	if not owned_heroes.has(hero_id):
		return false
	var rec: Dictionary = owned_heroes[hero_id]
	var stars := int(rec["stars"])
	if stars >= 3:
		return false
	var need := get_star_shard_cost(stars)
	if int(rec["shards"]) < need:
		return false
	rec["shards"] = int(rec["shards"]) - need
	rec["stars"] = stars + 1
	owned_heroes[hero_id] = rec
	save_game()
	roster_changed.emit()
	return true


func evolve_hero(hero_id: String, target_branch: String) -> bool:
	if hero_id != "knight" or not owned_heroes.has("knight"):
		return false
	var rec: Dictionary = owned_heroes["knight"]
	var cur_evo := String(rec["evo"])
	var lv := int(rec["level"])
	if target_branch == "advance" and cur_evo == "basic" and lv >= 5 and gold >= 1200:
		gold -= 1200
		rec["evo"] = "advance"
	elif target_branch in ["fire", "holy"] and cur_evo in ["basic", "advance"] and lv >= 10 and gold >= 2500:
		gold -= 2500
		rec["evo"] = target_branch
	else:
		return false
	owned_heroes["knight"] = rec
	save_game()
	resources_changed.emit()
	roster_changed.emit()
	return true


func can_afford_summon(count: int) -> bool:
	if tickets >= count:
		return true
	var gem_cost := 300 if count == 1 else 2700
	return gems >= gem_cost


func summon_gacha(count: int) -> Array:
	if count != 1 and count != 10:
		return []
	if not can_afford_summon(count):
		return []

	if tickets >= count:
		tickets -= count
	else:
		gems -= (300 if count == 1 else 2700)

	var results: Array = []
	var has_sr_plus := false
	for i in count:
		pity_counter += 1
		var rarity := _roll_rarity(pity_counter >= PITY_THRESHOLD, (count == 10 and i == 9 and not has_sr_plus))
		if rarity in ["SR", "SSR", "UR"]:
			has_sr_plus = true
		if rarity in ["SSR", "UR"]:
			pity_counter = 0

		var hero_id := _pick_hero_of_rarity(rarity)
		var is_new := not owned_heroes.has(hero_id)
		var shards_gained := 0
		if is_new:
			owned_heroes[hero_id] = {"level": 1, "stars": 1, "shards": 0, "evo": "basic"}
		else:
			shards_gained = 10 if rarity in ["SSR", "UR"] else 5
			owned_heroes[hero_id]["shards"] = int(owned_heroes[hero_id]["shards"]) + shards_gained

		results.append({
			"hero_id": hero_id,
			"rarity": rarity,
			"is_new": is_new,
			"shards_gained": shards_gained,
		})

	save_game()
	resources_changed.emit()
	roster_changed.emit()
	return results


func _roll_rarity(force_pity: bool, force_sr_plus: bool) -> String:
	if force_pity:
		return "UR" if randf() < 0.18 else "SSR"
	var roll := randf() * 100.0
	if roll < 1.5:
		return "UR"
	if roll < 10.0:
		return "SSR"
	if roll < 38.0 or force_sr_plus:
		return "SR"
	return "R"


func _pick_hero_of_rarity(rarity: String) -> String:
	var pool: Array[String] = []
	for hid in GameData.HEROES:
		if String(GameData.HEROES[hid]["rarity"]) == rarity:
			pool.append(String(hid))
	if pool.is_empty():
		return "knight"
	return pool[randi() % pool.size()]


func get_pending_idle_rewards(now_unix: int = -1) -> Dictionary:
	var now := now_unix if now_unix >= 0 else int(Time.get_unix_time_from_system())
	var elapsed := clampi(now - last_idle_claim_unix, 0, IDLE_CAP_SECONDS)
	var mins := float(elapsed) / 60.0
	var rate_mult := 1.0 + float(max_stage_unlocked - 1) * 0.15
	return {
		"elapsed_sec": elapsed,
		"gold": int(round(mins * 18.0 * rate_mult)),
		"exp": int(round(mins * 14.0 * rate_mult)),
		"gems": int(floor(mins / 30.0) * 5.0),
	}


func claim_idle_rewards(now_unix: int = -1) -> Dictionary:
	var now := now_unix if now_unix >= 0 else int(Time.get_unix_time_from_system())
	var rew := get_pending_idle_rewards(now)
	gold += int(rew["gold"])
	exp_pool += int(rew["exp"])
	gems += int(rew["gems"])
	last_idle_claim_unix = now
	save_game()
	resources_changed.emit()
	return rew


func complete_stage(stage_num: int) -> Dictionary:
	var data := GameData.get_stage_data(stage_num)
	gold += int(data["reward_gold"])
	exp_pool += int(data["reward_exp"])
	gems += int(data["reward_gems"])
	if stage_num >= max_stage_unlocked and max_stage_unlocked < 20:
		max_stage_unlocked = stage_num + 1
		selected_stage = max_stage_unlocked
	save_game()
	resources_changed.emit()
	return data
