extends Node2D

var basicRange = preload("res://enemy/rangedBasic/enemy_range.tscn")


func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	var range1 = basicRange.instantiate()
	range1.global_position = Vector2(518.0, -600.0)
	range1.cardChance = 50
	add_child(range1)
	var range2 = basicRange.instantiate()
	range2.global_position = Vector2(-525.0, 0.0)
	range2.cardChance = 50
	add_child(range2)
	var range3 = basicRange.instantiate()
	range3.global_position = Vector2(-518.0, -400.0)
	range3.cardChance = 50
	add_child(range3)
	var range4 = basicRange.instantiate()
	range4.global_position = Vector2(-518.0, -900.0)
	range4.cardChance = 50
	add_child(range4)
	var range5 = basicRange.instantiate()
	range5.global_position = Vector2(518.0, -1050.0)
	range5.cardChance = 50
	add_child(range5)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_level_6_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.
