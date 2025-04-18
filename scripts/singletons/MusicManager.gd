extends AudioStreamPlayer


@export var ost : Dictionary = {}
var fade_step = 5
var stored_db = 0

const MUTE_DB = -80
const MAX_DB = 0


func _ready():
	song("test")

func song_playing(sng):
	for key in ost.keys():
		if stream == ost.get(key) and key == sng:
			return true
	return false
	
func toggle() -> bool:
	if volume_db == MUTE_DB:
		unmute_music()
		return true
	else:
		mute_music()
		return false

func mute_music():
	stored_db = volume_db
	volume_db = MUTE_DB
	
func unmute_music():
	volume_db = stored_db
#	print("Unmute music to %s" % stored_db)
	Sound.sound("click")


func fade():
	while volume_db > MUTE_DB:
		volume_db -= fade_step
		await get_tree().create_timer(0.1).timeout
	stream_paused = true
	stream = null
	stop()

func song(sng = "", fade = false):
	if song_playing(sng):
		return
	
	stop()
	var last_song = stream
	if ost.has(sng) and stream != ost.get(sng):
		if fade and stream != null:
			while volume_db > MUTE_DB:
				volume_db -= fade_step
				await get_tree().create_timer(0.05).timeout
		stop()
		stream = ost.get(sng)
		if fade:
			while volume_db < stored_db:
				volume_db = clamp(volume_db + fade_step, MUTE_DB, stored_db)
				await get_tree().create_timer(0.05).timeout
		play()
#		print("Playing now ", stream)
		emit_signal("finished", last_song)


func on_range_change(value):
	volume_db = value
	Sound.sound("click")
