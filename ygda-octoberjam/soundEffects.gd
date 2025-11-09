extends Node

var sfx = {
	"cardPickup" : preload("res://sfx/sfx/card pickup.wav"),
	"enemy" : preload("res://sfx/sfx/enemy scream.wav"),
	"dash" : preload("res://sfx/sfx/dash.wav"),
	"fireball" : preload("res://sfx/sfx/fireball.wav"),
	"hit" : preload("res://sfx/sfx/hitHurt.wav"),
	"jump" : preload("res://sfx/sfx/jump.wav"),
	"dagger" : preload("res://sfx/sfx/knife clang.wav"),
	"basicattack" : preload("res://sfx/sfx/staff hit.wav"),
	"sword" : preload("res://sfx/sfx/sword.wav"),
	"walk" : preload("res://sfx/sfx/walk (repeat while walking).wav"),
	"warp" : preload("res://sfx/sfx/warp.wav")
}

var volume: float = 1.0

func play_sfx(name: String):
	if name not in sfx:
		return
	
	var audio = AudioStreamPlayer.new()
	
	add_child(audio)
	audio.stream = sfx[name]
	audio.play()
	await audio.finished
	audio.queue_free()
