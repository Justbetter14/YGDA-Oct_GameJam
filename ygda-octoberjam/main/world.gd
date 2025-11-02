extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_player_death() -> void:
	print("World Found Player Death")
	$Main.hide()
	$UserInterface/Retry.show()
	$RetryCamera.make_current()

func _unhandled_input(event):
	if event.is_action_pressed("Select") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
	
