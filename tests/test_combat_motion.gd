extends SceneTree

var _failures := 0
var _arena := Node2D.new()
var _battle_unit: GDScript


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		push_error(message)


func _run() -> void:
	Engine.max_fps = 60
	_battle_unit = load("res://scripts/battle/battle_unit.gd")
	root.add_child(_arena)
	var data := root.get_node("GameData")
	var clips: Dictionary = {}
	for id in data.HEROES:
		clips[id] = data.get_hero_anim_map(id)
	for tier in ["fire", "holy"]:
		clips["knight_" + tier] = data.get_hero_anim_map("knight", tier)
	for id in data.ENEMIES:
		clips[id] = data.get_enemy_anim_map(id)

	for speed in [1.0, 2.0]:
		Engine.time_scale = speed
		await _verify_contacts(clips)
		await _verify_projectile()
		await _verify_flank()
	Engine.time_scale = 1.0
	_arena.queue_free()
	await process_frame
	print("Combat motion at 1x and 2x, %d actors, %d failures" % [clips.size(), _failures])
	quit(1 if _failures else 0)


func _verify_contacts(clips: Dictionary) -> void:
	for skill in [false, true]:
		var counts: Dictionary = {}
		var units: Array[UnitVisual] = []
		var key := "skill" if skill else "attack"
		for id in clips:
			var unit := UnitVisual.new()
			_arena.add_child(unit)
			unit.configure_animations(clips[id])
			var expected: int = clips[id][key]["contact"]
			counts[id] = 0
			unit.impact_hit.connect(func(is_skill: bool) -> void:
				counts[id] += 1
				var sprite: Sprite2D = unit.get_node("VisualPivot/Sprite")
				_expect(is_skill == skill and sprite.frame == expected, "%s released outside its %s cel" % [id, key])
			)
			unit.play_action(skill, unit.global_position, false, true)
			units.append(unit)
		await create_timer(0.88).timeout
		for id in counts:
			_expect(counts[id] == 1, "%s emitted %d %s impacts" % [id, counts[id], key])
		for unit in units:
			_expect(unit.current_state == "idle", "%s did not recover to idle" % key)
			unit.queue_free()


func _verify_projectile() -> void:
	var archer : Node2D = _battle_unit.new()
	var target : Node2D = _battle_unit.new()
	_arena.add_child(archer)
	_arena.add_child(target)
	archer.setup_hero("archer", {}, 2, {}, Vector2(95, 440))
	target.setup_enemy("boss_ice_dragon", 2, 2.0, Vector2(622, 445))
	var hp: float = target.hp
	var release := {"time": 0}
	var arrival := {"time": 0}
	archer.visual.impact_hit.connect(func(_is_skill: bool) -> void:
		release["time"] = Time.get_ticks_usec()
		_expect(is_equal_approx(target.hp, hp), "Target lost HP before projectile arrived")
	)
	archer.action_resolved.connect(func(_caster: Node2D, _target: Node2D, _skill: bool, events: Array) -> void:
		arrival["time"] = Time.get_ticks_usec()
		_expect(events.size() == 1 and target.hp < hp, "Projectile arrived without applying one hit")
	)
	archer.attack_cooldown = 0.0
	archer.tick_combat(0.0, [archer], [target])
	await create_timer(1.1).timeout
	_expect(release["time"] > 0 and arrival["time"] - release["time"] > 110000,
		"Projectile flight must be visible at both speeds")
	_expect(archer.position.is_equal_approx(Vector2(95, 440)), "Ranged unit drifted from formation")
	_expect(archer.visual.current_state == "idle", "Caster did not finish recovery")
	archer.queue_free()
	target.queue_free()


func _verify_flank() -> void:
	var assassin : Node2D = _battle_unit.new()
	var target : Node2D = _battle_unit.new()
	_arena.add_child(assassin)
	_arena.add_child(target)
	var home := Vector2(106, 485)
	assassin.setup_hero("assassin", {}, 2, {}, home)
	target.setup_enemy("dark_mage", 2, 2.0, Vector2(585, 450))
	var outcome := {"run": false, "hit": false}
	assassin.visual.state_changed.connect(func(state: String) -> void:
		if state == "run":
			outcome["run"] = true
	)
	assassin.action_resolved.connect(func(_caster: Node2D, _target: Node2D, skill: bool, events: Array) -> void:
		outcome["hit"] = skill and events.size() == 1
		_expect(assassin.position.x > target.position.x and assassin.visual.facing_sign < 0.0,
			"Assassin must strike from behind the opponent while facing it")
	)
	assassin.energy = assassin.max_energy
	assassin.attack_cooldown = 0.0
	assassin.tick_combat(0.0, [assassin], [target])
	await create_timer(2.1).timeout
	_expect(outcome["hit"] and outcome["run"], "Assassin did not run and resolve the Ultimate")
	_expect(assassin.position.is_equal_approx(home) and assassin.visual.current_state == "idle",
		"Assassin did not return to its formation slot")
	assassin.queue_free()
	target.queue_free()
