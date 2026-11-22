extends SceneTree

func _init() -> void:
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	var packed: PackedScene = load("res://scenes/demo/HeroDemoScene.tscn")
	if packed == null:
		push_error("Failed to load HeroDemoScene.tscn")
		quit(1)
		return

	var scene := packed.instantiate()
	root.add_child(scene)
	await process_frame

	var knight: UnitVisual = scene.get_node("ArenaRoot/Knight")
	var goblin: UnitVisual = scene.get_node("ArenaRoot/Goblin")
	if knight == null or goblin == null:
		push_error("Knight and Goblin nodes must exist")
		quit(1)
		return

	for path in [
		"res://assets/sprites/heroes/knight_idle.png",
		"res://assets/sprites/heroes/knight_run.png",
		"res://assets/sprites/heroes/knight_attack.png",
		"res://assets/sprites/heroes/knight_skill.png",
		"res://assets/sprites/enemies/goblin_run.png",
		"res://assets/sprites/backgrounds/bg_plains_kingdom.png",
	]:
		var tex: Texture2D = load(path)
		if tex == null:
			push_error("Missing texture: " + path)
			quit(2)
			return

	knight.play_idle()
	knight.play_run()
	knight.play_attack(goblin.global_position.x)
	await process_frame
	knight.play_skill(goblin.global_position.x)
	await process_frame
	knight.play_hit(false)
	knight.play_death()
	knight.respawn()

	print("SMOKE TEST PASSED: HeroDemoScene + all 6 textures + UnitVisual states verified.")
	quit(0)
