extends Node

var currentLevel = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()
	$RetryCamera.enabled = false
	#add_child(load("res://main/Levels/1.tscn").instantiate())
func _unhandled_input(event):
	if event.is_action_pressed("Select") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()

func nextLevel():
	remove_child(get_node(str(currentLevel))) 
	currentLevel += 1
	var temp = str("res://main/Levels/",currentLevel,".tscn")
	add_child(load(temp).instantiate())
