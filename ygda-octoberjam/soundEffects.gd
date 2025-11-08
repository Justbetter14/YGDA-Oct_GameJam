extends Node

var sfx = {
	#"temp" : preload("res://audio/test1.wav")
}

var volume: float = 1.0

func play_sfx(name: String):
	if name not in sfx:
		return
	
	var audio = AudioStreamPlayer.new()
	
	add_child(audio)
	audio.stream = sfx[name]
	connect("finished", Callable(audio, "queue_free"))
	audio.play()
