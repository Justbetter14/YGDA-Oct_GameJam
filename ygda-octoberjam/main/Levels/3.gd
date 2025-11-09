extends Node2D

var basicEnemy = preload("res://enemy/meleeBasic/enemy_melee.tscn")
var basicRange = preload("res://enemy/rangedBasic/enemy_range.tscn")

func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	var melee1 = basicEnemy.instantiate()
	melee1.global_position = Vector2(-518.0, -413.0)
	melee1.cardChance = 100
	add_child(melee1)
	var melee2 = basicEnemy.instantiate()
	melee2.global_position = Vector2(3.0, -1437.0)
	melee2.cardChance = 100
	add_child(melee2)
	var range1 = basicRange.instantiate()
	range1.global_position = Vector2(-389.0, -994.0)
	range1.cardChance = 50
	add_child(range1)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_player_death() -> void:
	print("level 3 death")
	get_parent().death()

func _on_level_3_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()
