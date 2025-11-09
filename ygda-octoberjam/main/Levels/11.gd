extends Node2D

var cardSlot = preload("res://Cards/Resources/doublejumpCard.tres")

func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	$CanvasLayer/Inventory/GridContainer/cardButton1.icon = cardSlot.texture

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.


func _on_level_11_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()
