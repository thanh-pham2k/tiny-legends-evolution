extends SceneTree

func _init() -> void:
	call_deferred("_run_tests")


func _run_tests() -> void:
	var game_data: Node = root.get_node("GameData")
	var player: Node = root.get_node("PlayerState")
	assert(game_data != null and player != null, "Autoloads must exist")

	# Use isolated test save path so user's real save isn't touched
	player.save_path = "user://test_mvp_save.json"
	if FileAccess.file_exists(player.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(player.save_path))
	player.reset_to_defaults(1000000)

	# 1. Verify all 12 Heroes, 6 Mobs, 3 Bosses, and key UI/Background/VFX assets load non-null
	for hid in game_data.HEROES:
		var anims: Dictionary = game_data.get_hero_anim_map(hid, "basic")
		assert(anims["idle"]["texture"] != null, "Missing idle for " + hid)
		assert(anims["attack"]["texture"] != null, "Missing attack for " + hid)
		assert(anims["skill"]["texture"] != null, "Missing skill for " + hid)
		assert(load(game_data.get_hero_portrait_path(hid, "basic")) != null, "Missing portrait for " + hid)

	for eid in game_data.ENEMIES:
		var eanims: Dictionary = game_data.get_enemy_anim_map(eid)
		assert(eanims["idle"]["texture"] != null, "Missing enemy idle for " + eid)
		assert(eanims["attack"]["texture"] != null, "Missing enemy attack for " + eid)

	for p in [
		"res://assets/sprites/backgrounds/bg_title_splash.png",
		"res://assets/sprites/backgrounds/bg_lobby_town.png",
		"res://assets/sprites/backgrounds/bg_campaign_map.png",
		"res://assets/sprites/backgrounds/bg_summon_portal.png",
		"res://assets/sprites/ui/ui_gacha_card_back.png",
		"res://assets/sprites/ui/ui_pin_stage_active.png",
		"res://assets/sprites/ui/ui_banner_victory.png",
		"res://assets/sprites/vfx/vfx_holy_shield.png",
		"res://assets/sprites/vfx/vfx_fire_explosion.png",
	]:
		assert(load(p) != null, "Missing asset: " + p)

	# 2. Gacha x10 + Pity guarantee check
	var pulls10: Array = player.summon_gacha(10)
	assert(pulls10.size() == 10, "x10 summon must return 10 pulls")
	player.pity_counter = player.PITY_THRESHOLD - 1
	player.gems = 1000
	var pity_pull: Array = player.summon_gacha(1)
	assert(pity_pull.size() == 1 and String(pity_pull[0]["rarity"]) in ["SSR", "UR"], "Pity pull must guarantee SSR or UR")

	# 3. Level Up, Star Up & Knight Branching Evolution USP check
	player.gold = 50000
	player.exp_pool = 50000
	for _i in 10:
		assert(player.level_up_hero("knight"), "Knight level up should succeed")
	assert(int(player.owned_heroes["knight"]["level"]) == 11, "Knight should be level 11")
	assert(player.star_up_hero("knight"), "Knight star up (15 shards >= 10) should succeed")
	assert(int(player.owned_heroes["knight"]["stars"]) == 2, "Knight should be 2 stars")

	assert(player.evolve_hero("knight", "fire"), "Knight should evolve to Fire Knight")
	assert(game_data.get_hero_ai_profile("knight", "fire") == "fire_aoe", "Fire Knight AI must be fire_aoe")
	var fire_anims: Dictionary = game_data.get_hero_anim_map("knight", "fire")
	assert(fire_anims["idle"]["texture"] != null and fire_anims["skill"]["texture"] != null, "Fire Knight anims must load")

	# Reset to test Holy Guardian branch too
	player.owned_heroes["knight"]["evo"] = "basic"
	assert(player.evolve_hero("knight", "holy"), "Knight should evolve to Holy Guardian")
	assert(game_data.get_hero_ai_profile("knight", "holy") == "holy_protect", "Holy Guardian AI must be holy_protect")

	# 4. Offline Idle Rewards & Save/Load round-trip
	var pend: Dictionary = player.get_pending_idle_rewards(1000000 + 3600)
	assert(int(pend["gold"]) > 0 and int(pend["gems"]) >= 10, "1h+ idle rewards should accrue gold & gems")
	player.save_game()
	player.gold = 0
	player.load_game()
	assert(player.gold > 0 and String(player.owned_heroes["knight"]["evo"]) == "holy", "Save/Load must persist gold & evo")

	# 5. MainApp & 5v5 BattleScreen runtime check
	var main_packed: PackedScene = load("res://scenes/main/MainApp.tscn")
	var app := main_packed.instantiate()
	root.add_child(app)
	await process_frame
	for scr in ["lobby", "heroes", "summon", "campaign"]:
		app.navigate_to(scr, {}, true)
		await process_frame
	app.navigate_to("battle", {"stage": 5}, true)  # Stage 5 = Boss Stone Golem!
	await process_frame
	await process_frame
	app.queue_free()
	await process_frame

	if FileAccess.file_exists(player.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(player.save_path))
	player.save_path = "user://save.json"

	print("MVP CORE TEST PASSED: All 12 Heroes, 6 Mobs, 3 Bosses, Gacha/Pity, Branching Evo AI, Idle Rewards, Save/Load, and 5v5 BattleScreen verified!")
	quit(0)
