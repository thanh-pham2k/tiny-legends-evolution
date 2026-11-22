extends Node

var muted: bool = false
var _streams: Dictionary = {}
var _players: Array[AudioStreamPlayer] = []
const POOL_SIZE := 10
var _pool_idx: int = 0


func _ready() -> void:
	_build_player_pool()
	_generate_sfx_library()


func _build_player_pool() -> void:
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.name = "SfxPlayer_%d" % i
		add_child(p)
		_players.append(p)


func set_muted(is_muted: bool) -> void:
	muted = is_muted
	if muted:
		for p in _players:
			if p.playing:
				p.stop()


func play_sfx(sfx_name: String, volume_db: float = -6.0, pitch_scale: float = 1.0) -> void:
	if muted or not _streams.has(sfx_name) or _players.is_empty():
		return
	var p: AudioStreamPlayer = _players[_pool_idx]
	_pool_idx = (_pool_idx + 1) % _players.size()
	p.stop()
	p.stream = _streams[sfx_name]
	p.volume_db = volume_db
	p.pitch_scale = pitch_scale * randf_range(0.96, 1.04)
	p.play()


func _generate_sfx_library() -> void:
	_streams["ui_click"] = _make_tone_wav(740.0, 520.0, 0.055, "sine", 0.35)
	_streams["sword_hit"] = _make_noise_sweep_wav(0.11, 280.0, 90.0, 0.45)
	_streams["crit_hit"] = _make_noise_sweep_wav(0.16, 460.0, 120.0, 0.60)
	_streams["skill_cast"] = _make_chord_wav([440.0, 660.0, 880.0], 0.24, 0.40)
	_streams["heal_chime"] = _make_chord_wav([587.3, 880.0, 1174.6], 0.28, 0.35)
	_streams["gacha_pull"] = _make_tone_wav(320.0, 960.0, 0.32, "triangle", 0.40)
	_streams["gacha_ssr"] = _make_chord_wav([523.25, 659.25, 783.99, 1046.5], 0.48, 0.45)
	_streams["level_up"] = _make_chord_wav([493.88, 659.25, 987.77], 0.24, 0.38)
	_streams["chest_open"] = _make_chord_wav([440.0, 554.37, 659.25, 880.0], 0.36, 0.42)
	_streams["victory"] = _make_chord_wav([523.25, 659.25, 783.99, 1046.5], 0.55, 0.45)
	_streams["defeat"] = _make_tone_wav(340.0, 130.0, 0.42, "saw", 0.34)


func _make_tone_wav(f_start: float, f_end: float, dur: float, wave_type: String, amp: float) -> AudioStreamWAV:
	var rate := 22050
	var n := int(dur * rate)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phase := 0.0
	for i in n:
		var t := float(i) / float(n)
		var freq := lerpf(f_start, f_end, t)
		phase += TAU * freq / float(rate)
		var env := (1.0 - t) * minf(1.0, t * 18.0)
		var s := 0.0
		match wave_type:
			"triangle":
				s = 2.0 * absf(2.0 * (phase / TAU - floorf(phase / TAU + 0.5))) - 1.0
			"saw":
				s = 2.0 * (phase / TAU - floorf(phase / TAU + 0.5))
			_:
				s = sin(phase)
		var val := int(clampf(s * env * amp, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, val)
	return _pack_wav(data, rate)


func _make_noise_sweep_wav(dur: float, f_start: float, f_end: float, amp: float) -> AudioStreamWAV:
	var rate := 22050
	var n := int(dur * rate)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phase := 0.0
	for i in n:
		var t := float(i) / float(n)
		var freq := lerpf(f_start, f_end, t)
		phase += TAU * freq / float(rate)
		var env := pow(1.0 - t, 1.6)
		var s := sin(phase) * 0.65 + randf_range(-1.0, 1.0) * 0.35
		var val := int(clampf(s * env * amp, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, val)
	return _pack_wav(data, rate)


func _make_chord_wav(freqs: Array, dur: float, amp: float) -> AudioStreamWAV:
	var rate := 22050
	var n := int(dur * rate)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phases: Array[float] = []
	for _f in freqs:
		phases.append(0.0)
	for i in n:
		var t := float(i) / float(n)
		var env := pow(1.0 - t, 1.15) * minf(1.0, t * 24.0)
		var s := 0.0
		for j in freqs.size():
			phases[j] += TAU * float(freqs[j]) / float(rate)
			s += sin(phases[j])
		s /= float(maxi(1, freqs.size()))
		var val := int(clampf(s * env * amp, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, val)
	return _pack_wav(data, rate)


func _pack_wav(data: PackedByteArray, rate: int) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = data
	return wav


func _exit_tree() -> void:
	for p in _players:
		if is_instance_valid(p):
			p.stop()
