extends Node2D

var basicEnemy = preload("res://enemy/meleeBasic/enemy_melee.tscn")

func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	var melee1 = basicEnemy.instantiate()
	melee1.global_position = Vector2(-518.0, -413.0)
	melee1.cardChance = 33
	melee1.cardsList = []
	add_child(melee1)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.


func _on_level_9_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()
