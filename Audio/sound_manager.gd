# SoundManager.gd (autoload)
extends Node

const POOL_SIZE = 8
var players: Array[AudioStreamPlayer] = []
var sfx_library := {
	"footsteps_stone_1": preload("uid://dhshd6qffu4h"),
	"footsteps_stone_2": preload("uid://crjl04flvkw6d"),
	"footsteps_sand_1": preload("res://Audio/footsteps_sand_1.wav"),
	"footsteps_sand_2": preload("res://Audio/footsteps_sand_2.wav"),
	"footsteps_sand_3": preload("res://Audio/footsteps_sand_3.wav"),
  # "gunshot": preload("res://audio/sfx/gunshot.wav"),
   # "hit": preload("res://audio/sfx/hit.wav"),
}

func _ready():
	for i in POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		players.append(p)

func play_sfx(name: String, volume_db := 0.0, pitch_variation := 0.05):
	print("play_sfx called with: ", name)
	if not sfx_library.has(name):
		return
	for p in players:
		if not p.playing:
			print("playing on pooled player")
			p.stream = sfx_library[name]
			p.volume_db = volume_db
			p.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
			p.play()
			return
			
			
			
			
var music_players: Array[AudioStreamPlayer] = []
var active_music_index := 0
const CROSSFADE_TIME := 1.5
var music_library := {
	#"town": preload("res://audio/music/town.ogg"),
	#"combat": preload("res://audio/music/combat.ogg"),
}
func play_music(name: String, fade_time := CROSSFADE_TIME):
	if not music_library.has(name):
		return

	var next_index = 1 - active_music_index
	var current_player = music_players[active_music_index]
	var next_player = music_players[next_index]

	# Don't restart if it's already the track playing
	if current_player.stream == music_library[name] and current_player.playing:
		return

	next_player.stream = music_library[name]
	next_player.volume_db = -80.0
	next_player.play()

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(next_player, "volume_db", 0.0, fade_time)
	if current_player.playing:
		tween.tween_property(current_player, "volume_db", -80.0, fade_time)
		tween.chain().tween_callback(current_player.stop)

	active_music_index = next_index
	
	
var footstep_sets := {
	"dirt": ["footstep_dirt"],
	"sand": ["footsteps_sand_1", "footsteps_sand_2", "footsteps_sand_3"],
	"stone": ["footsteps_stone_1", "footsteps_stone_2"],
}

func play_footstep(surface := "stone"):
	var options = footstep_sets.get(surface, footstep_sets["stone"])
	SoundManager.play_sfx(options[randi() % options.size()])
