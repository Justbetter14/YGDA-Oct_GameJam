extends Node

var currentLevel = 0

func nextLevel():
	remove_child(get_node(str(currentLevel))) 
	currentLevel += 1
	var temp = str("res://main/Levels/", currentLevel, ".tscn")
	add_child(load(temp).instantiate())
	SoundEffects.play_sfx("warp")
	
func death():
	remove_child(get_node(str(currentLevel)))
	print("void killed")
	var temp = str("res://main/Levels/", currentLevel, ".tscn")
	add_child(load(temp).instantiate())
