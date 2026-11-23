class_name BattleUnit
extends Node2D

signal action_resolved(caster: BattleUnit, target: BattleUnit, is_skill: bool, events: Array)
signal died(unit: BattleUnit)
signal bars_updated(unit: BattleUnit)

var unit_id: String = ""
var display_name: String = ""
var is_hero: bool = true
var is_boss: bool = false
var is_backline: bool = false
var slot_index: int = 0
var element: String = "light"
var role: String = "warrior"
var ai_profile: String = "dps_nearest"
var attack_range: String = "melee"
var skill_name: String = "Skill"
var vfx_path: String = "res://assets/sprites/vfx/vfx_fire_slash_single.png"

var max_hp: float = 1000.0
var hp: float = 1000.0
var white_hp: float = 1000.0
var shield: float = 0.0
var atk: float = 120.0
var def_stat: float = 50.0
var spd: float = 100.0
var energy: float = 0.0
var max_energy: float = 100.0
var attack_cooldown: float = 1.0
var is_dead: bool = false

var visual: UnitVisual
var _hp_bg: ColorRect
var _hp_white: ColorRect
var _hp_fill: ColorRect
var _shield_fill: ColorRect
var _en_fill: ColorRect
var _name_lbl: Label

var _home_pos: Vector2 = Vector2.ZERO
var _action_busy: bool = false
var _pending_skill: bool = false
var _pending_allies: Array = []
var _pending_enemies: Array = []
var _pending_target: BattleUnit = null
var _impact_pending := false
var _visual_finished := true


func setup_hero(hero_id: String, rec: Dictionary, slot_idx: int, synergy: Dictionary, world_pos: Vector2) -> void:
	is_hero = true
	unit_id = hero_id
	slot_index = slot_idx
	is_backline = slot_idx >= 2
	_home_pos = world_pos
	position = world_pos

	var base: Dictionary = GameData.HEROES[hero_id]
	var lv := int(rec.get("level", 1))
	var stars := int(rec.get("stars", 1))
	var evo := String(rec.get("evo", "basic"))
	var st := GameData.get_hero_stats(hero_id, lv, stars, evo)
	var sk := GameData.get_hero_skill_info(hero_id, evo)

	display_name = GameData.get_hero_display_name(hero_id, evo)
	element = String(base["element"])
	role = String(base["role"])
	ai_profile = GameData.get_hero_ai_profile(hero_id, evo)
	attack_range = String(base["range"])
	skill_name = String(sk["name"])
	vfx_path = String(sk["vfx"])

	max_hp = float(st["hp"]) * (1.0 + float(synergy.get("hp_bonus", 0.0)))
	hp = max_hp
	white_hp = max_hp
	atk = float(st["atk"]) * (1.0 + float(synergy.get("atk_bonus", 0.0)))
	def_stat = float(st["def"])
	spd = float(st["spd"])
	energy = 25.0 + float(slot_idx) * 5.0
	attack_cooldown = randf_range(0.35, 0.85)

	_build_visual(GameData.get_hero_anim_map(hero_id, evo), 1.0, 1.38)
	if hero_id == "knight" and evo == "fire":
		visual.set_aura(Color(1.0, 0.36, 0.14), true)
	elif hero_id == "knight" and evo == "holy":
		visual.set_aura(Color(1.0, 0.88, 0.32), true)
	_build_bars()


func setup_enemy(enemy_id: String, slot_idx: int, stat_scale: float, world_pos: Vector2) -> void:
	is_hero = false
	unit_id = enemy_id
	slot_index = slot_idx
	is_backline = slot_idx >= 2
	_home_pos = world_pos
	position = world_pos

	var base: Dictionary = GameData.ENEMIES[enemy_id]
	is_boss = bool(base.get("is_boss", false))
	display_name = String(base["name"])
	element = String(base["element"])
	role = String(base["role"])
	ai_profile = String(base["ai_profile"])
	attack_range = String(base["range"])
	skill_name = display_name + " Fury"
	vfx_path = String(base["vfx"])

	max_hp = float(base["hp"]) * stat_scale
	hp = max_hp
	white_hp = max_hp
	atk = float(base["atk"]) * stat_scale
	def_stat = float(base["def"]) * stat_scale * 0.75
	spd = float(base["spd"])
	energy = 15.0 + float(slot_idx) * 6.0
	attack_cooldown = randf_range(0.5, 1.1)

	var sc := 1.25 if is_boss else 1.28
	_build_visual(GameData.get_enemy_anim_map(enemy_id), -1.0, sc)
	if is_boss:
		visual.set_aura(Color(0.95, 0.25, 0.32), true)
	_build_bars()


func _build_visual(anim_map: Dictionary, f_sign: float, u_scale: float) -> void:
	visual = UnitVisual.new()
	visual.facing_sign = f_sign
	visual.art_facing = f_sign
	visual.motion_root = self
	visual.home_position = _home_pos
	visual.unit_scale = u_scale
	visual.juice_enabled = true
	add_child(visual)
	visual.configure_animations(anim_map)
	visual.impact_hit.connect(_on_visual_impact)
	visual.action_finished.connect(func() -> void:
		_visual_finished = true
		_action_busy = _impact_pending
	)


func _build_bars() -> void:
	var bar_w := 98.0 if is_boss else 74.0
	var top_y := -185.0 if is_boss else -148.0

	_name_lbl = Label.new()
	_name_lbl.text = display_name
	_name_lbl.position = Vector2(-bar_w * 0.5 - 24.0, top_y - 20.0)
	_name_lbl.custom_minimum_size = Vector2(bar_w + 48.0, 18.0)
	_name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_lbl.add_theme_font_size_override("font_size", 13 if is_boss else 11)
	_name_lbl.add_theme_color_override("font_color", Color(1.0, 0.90, 0.45) if is_boss else Color(0.95, 0.97, 1.0))
	_name_lbl.add_theme_color_override("font_outline_color", Color(0.05, 0.05, 0.08))
	_name_lbl.add_theme_constant_override("outline_size", 3)
	add_child(_name_lbl)

	_hp_bg = ColorRect.new()
	_hp_bg.color = Color(0.08, 0.08, 0.12, 0.88)
	_hp_bg.position = Vector2(-bar_w * 0.5, top_y)
	_hp_bg.size = Vector2(bar_w, 12.0)
	add_child(_hp_bg)

	_hp_white = ColorRect.new()
	_hp_white.color = Color(1.0, 0.96, 0.85, 0.92)
	_hp_white.position = Vector2(1, 1)
	_hp_white.size = Vector2(bar_w - 2.0, 6.0)
	_hp_bg.add_child(_hp_white)

	_hp_fill = ColorRect.new()
	_hp_fill.color = Color(0.24, 0.86, 0.46) if is_hero else Color(0.94, 0.28, 0.30)
	_hp_fill.position = Vector2(1, 1)
	_hp_fill.size = Vector2(bar_w - 2.0, 6.0)
	_hp_bg.add_child(_hp_fill)

	_shield_fill = ColorRect.new()
	_shield_fill.color = Color(1.0, 0.86, 0.28, 0.95)
	_shield_fill.position = Vector2(1, 1)
	_shield_fill.size = Vector2(0.0, 2.0)
	_hp_bg.add_child(_shield_fill)

	_en_fill = ColorRect.new()
	_en_fill.color = Color(0.28, 0.82, 1.0)
	_en_fill.position = Vector2(1, 8)
	_en_fill.size = Vector2((bar_w - 2.0) * (energy / max_energy), 3.0)
	_hp_bg.add_child(_en_fill)


func tick_combat(delta: float, allies: Array, enemies: Array) -> void:
	if is_dead:
		return

	# Delayed white damage trail
	if white_hp > hp:
		white_hp = maxf(hp, white_hp - max_hp * 0.65 * delta)
		_refresh_bars()

	# Count cooldown from resolution while the visual completes its recovery.
	if not _impact_pending:
		attack_cooldown -= delta * (spd / 100.0)
	if _action_busy:
		return

	if attack_cooldown <= 0.0:
		var use_skill := energy >= max_energy
		var target := _select_target(allies, enemies, use_skill)
		if target == null:
			return
		_start_action(target, use_skill, allies, enemies)


func _select_target(allies: Array, enemies: Array, use_skill: bool) -> BattleUnit:
	var live_enemies := enemies.filter(func(u: BattleUnit) -> bool: return not u.is_dead)
	var live_allies := allies.filter(func(u: BattleUnit) -> bool: return not u.is_dead)
	if live_enemies.is_empty():
		return null

	match ai_profile:
		"assassin_backline":
			# Assassins prioritize backline squishies!
			var back := live_enemies.filter(func(u: BattleUnit) -> bool: return u.is_backline)
			var pool: Array = back if not back.is_empty() else live_enemies
			pool.sort_custom(func(a: BattleUnit, b: BattleUnit) -> bool: return a.hp < b.hp)
			return pool[0]
		"healer_lowest":
			if use_skill and not live_allies.is_empty():
				live_allies.sort_custom(func(a: BattleUnit, b: BattleUnit) -> bool: return (a.hp / a.max_hp) < (b.hp / b.max_hp))
				return live_allies[0]
			var hurt := live_allies.filter(func(u: BattleUnit) -> bool: return (u.hp / u.max_hp) < 0.88)
			if not hurt.is_empty():
				hurt.sort_custom(func(a: BattleUnit, b: BattleUnit) -> bool: return (a.hp / a.max_hp) < (b.hp / b.max_hp))
				return hurt[0]
		"holy_protect":
			if use_skill and not live_allies.is_empty():
				live_allies.sort_custom(func(a: BattleUnit, b: BattleUnit) -> bool: return (a.hp / a.max_hp) < (b.hp / b.max_hp))
				return live_allies[0]
		"tank_front", "fire_aoe", "dps_nearest":
			pass

	var front := live_enemies.filter(func(u: BattleUnit) -> bool: return not u.is_backline)
	var target_pool: Array = front if not front.is_empty() else live_enemies
	target_pool.sort_custom(func(a: BattleUnit, b: BattleUnit) -> bool:
		return absf(a.position.x - position.x) < absf(b.position.x - position.x)
	)
	return target_pool[0]


func _start_action(target: BattleUnit, use_skill: bool, allies: Array, enemies: Array) -> void:
	_action_busy = true
	_pending_skill = use_skill
	_pending_target = target
	_pending_allies = allies.duplicate()
	_pending_enemies = enemies.duplicate()
	attack_cooldown = 1.35 if use_skill else 1.15
	if use_skill:
		energy = 0.0
		_refresh_bars()

	_impact_pending = true
	_visual_finished = false
	var ranged := attack_range == "ranged"
	var hostile := target.is_hero != is_hero
	var flank := hostile and ai_profile == "assassin_backline"
	var destination := global_position
	if hostile and not ranged:
		var stride := 63.0 if flank else (103.0 if is_boss or target.is_boss else 79.0)
		var side := visual.facing_sign if flank else -visual.facing_sign
		var arena := get_parent() as Node2D
		var local_destination := target.position + Vector2(side * stride, 12.0 if flank else 6.0 * (slot_index - target.slot_index))
		local_destination.x = clampf(local_destination.x, 45.0, 675.0)
		destination = arena.to_global(local_destination)
	visual.play_action(use_skill, destination, flank, ranged, target if hostile else null)


func _on_visual_impact(_is_skill_sig: bool) -> void:
	if is_dead or not _impact_pending:
		return
	if attack_range == "ranged" and is_instance_valid(_pending_target) and _pending_target != self:
		var offset := Vector2(0.0, -108.0 if _pending_target.is_boss else -69.0)
		visual.fire_projectile(_pending_target, offset, unit_id, element, _pending_skill, _resolve_impact)
		return
	_resolve_impact()


func _resolve_impact() -> void:
	if is_dead or not _impact_pending:
		return
	_impact_pending = false
	_action_busy = not _visual_finished

	var events: Array = []
	var live_enemies := _pending_enemies.filter(func(u: BattleUnit) -> bool: return is_instance_valid(u) and not u.is_dead)
	var live_allies := _pending_allies.filter(func(u: BattleUnit) -> bool: return is_instance_valid(u) and not u.is_dead)

	if not _pending_skill:
		energy = minf(max_energy, energy + 34.0)
		_refresh_bars()
		if _pending_target != null and is_instance_valid(_pending_target) and not _pending_target.is_dead:
			if _pending_target.is_hero == is_hero:
				var heal_amt := atk * 1.15
				_pending_target.apply_heal(heal_amt)
				events.append({"kind": "heal", "unit": _pending_target, "amount": int(round(heal_amt)), "crit": false})
			else:
				events.append(_strike_enemy(_pending_target, 1.0, false))
				if attack_range == "ranged":
					var tint: Color = UnitVisual.ELEMENT_COLORS.get(element, Color.WHITE)
					_pending_target.visual.spawn_vfx_sprite(vfx_path, Vector2(0, -64), 0.52, tint)
	else:
		# Ultimate Skills driven by Role & USP Branch!
		if ai_profile == "holy_protect":
			for ally in live_allies:
				var sh_amt := max_hp * (0.30 if ally == _pending_target else 0.18)
				ally.apply_shield(sh_amt)
				var h_amt := atk * 0.95
				ally.apply_heal(h_amt)
				ally.visual.spawn_vfx_sprite(vfx_path, Vector2(0, -56), 1.15, Color(1.0, 0.94, 0.65))
				events.append({"kind": "shield", "unit": ally, "amount": int(round(sh_amt)), "crit": true})
		elif ai_profile == "healer_lowest":
			for ally in live_allies:
				var mult := 2.4 if ally == _pending_target else 1.55
				var h_amt := atk * mult
				ally.apply_heal(h_amt)
				ally.visual.spawn_vfx_sprite(vfx_path, Vector2(0, -48), 1.2, Color(0.85, 1.0, 0.9))
				events.append({"kind": "heal", "unit": ally, "amount": int(round(h_amt)), "crit": ally == _pending_target})
		elif ai_profile == "fire_aoe" or unit_id in ["mage", "enchanter", "berserker", "samurai", "archer"] or is_boss:
			var aoe_mult := 1.95 if ai_profile == "fire_aoe" else 1.65
			var targets := live_enemies.slice(0, 3) if unit_id == "archer" else live_enemies
			for foe in targets:
				var ev := _strike_enemy(foe, aoe_mult, ai_profile == "fire_aoe")
				foe.visual.spawn_vfx_sprite(vfx_path, Vector2(0, -56), 1.15)
				events.append(ev)
		else:
			if ai_profile == "tank_front":
				var self_sh := max_hp * 0.22
				apply_shield(self_sh)
				events.append({"kind": "shield", "unit": self, "amount": int(round(self_sh)), "crit": false})
			if _pending_target != null and is_instance_valid(_pending_target) and not _pending_target.is_dead:
				var force_crit := unit_id in ["sniper", "assassin", "ninja"]
				var ev := _strike_enemy(_pending_target, 2.55 if force_crit else 2.15, force_crit)
				_pending_target.visual.spawn_vfx_sprite(vfx_path, Vector2(0, -58), 1.3)
				events.append(ev)

	action_resolved.emit(self, _pending_target, _pending_skill, events)
	_pending_target = null
	_pending_allies.clear()
	_pending_enemies.clear()


func _strike_enemy(target: BattleUnit, dmg_mult: float, force_crit: bool) -> Dictionary:
	var el_mult := GameData.get_element_multiplier(element, target.element)
	var is_crit := force_crit or (randf() < (0.28 if role in ["assassin", "ranger"] else 0.16))
	var crit_mult := 1.55 if is_crit else 1.0
	var mitigation := 100.0 / (100.0 + target.def_stat * 0.75)
	var raw_dmg := atk * dmg_mult * el_mult * crit_mult * mitigation * randf_range(0.94, 1.06)
	var final_dmg := maxf(12.0, raw_dmg)
	target.take_damage(final_dmg, is_crit or _pending_skill)
	var stop := 0.068 if _pending_skill else 0.033
	visual.freeze_pose(stop)
	target.visual.freeze_pose(stop)
	return {
		"kind": "damage",
		"unit": target,
		"amount": int(round(final_dmg)),
		"crit": is_crit,
		"effective": el_mult > 1.0,
	}


func take_damage(amount: float, heavy: bool) -> void:
	if is_dead:
		return
	var rem := amount
	if shield > 0.0:
		var absorbed := minf(shield, rem)
		shield -= absorbed
		rem -= absorbed
	hp = maxf(0.0, hp - rem)
	energy = minf(max_energy, energy + 14.0)
	_refresh_bars()

	if hp <= 0.0:
		is_dead = true
		_action_busy = false
		_impact_pending = false
		_pending_target = null
		_pending_allies.clear()
		_pending_enemies.clear()
		_hp_bg.visible = false
		_name_lbl.visible = false
		visual.play_death()
		died.emit(self)
	elif _action_busy:
		visual.flash_hit(heavy)
	else:
		visual.play_hit(heavy)


func apply_heal(amount: float) -> void:
	if is_dead:
		return
	hp = minf(max_hp, hp + amount)
	if white_hp < hp:
		white_hp = hp
	_refresh_bars()


func apply_shield(amount: float) -> void:
	if is_dead:
		return
	shield = minf(max_hp * 0.65, shield + amount)
	_refresh_bars()


func _refresh_bars() -> void:
	if _hp_bg == null:
		return
	var inner_w := _hp_bg.size.x - 2.0
	_hp_fill.size.x = inner_w * clampf(hp / maxf(1.0, max_hp), 0.0, 1.0)
	_hp_white.size.x = inner_w * clampf(white_hp / maxf(1.0, max_hp), 0.0, 1.0)
	_shield_fill.size.x = inner_w * clampf(shield / maxf(1.0, max_hp), 0.0, 1.0)
	_en_fill.size.x = inner_w * clampf(energy / maxf(1.0, max_energy), 0.0, 1.0)
	bars_updated.emit(self)
