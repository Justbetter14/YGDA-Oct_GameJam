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
	melee2.global_position = Vector2(-6.0, -600.0)
	melee2.cardChance = 100
	add_child(melee2)
	var melee3 = basicEnemy.instantiate()
	melee3.global_position = Vector2(-400.0, -900.0)
	melee3.cardChance = 100
	add_child(melee3)
	var melee4 = basicEnemy.instantiate()
	melee4.global_position = Vector2(500.0, -413.0)
	melee4.cardChance = 100
	add_child(melee4)
	var range1 = basicRange.instantiate()
	range1.global_position = Vector2(518.0, -600.0)
	range1.cardChance = 50
	add_child(range1)
	var range2 = basicRange.instantiate()
	range2.global_position = Vector2(-525.0, 0.0)
	range2.cardChance = 50
	add_child(range2)
	var range3 = basicRange.instantiate()
	range3.global_position = Vector2(-518.0, -200.0)
	range3.cardChance = 50
	add_child(range3)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_level_5_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.
