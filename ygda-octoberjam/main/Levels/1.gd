extends Node2D

var basicEnemy = preload("res://enemy/meleeBasic/enemy_melee.tscn")

func _ready() -> void:
	var melee1 = basicEnemy.instantiate()
	melee1.global_position = Vector2(-518.0, -413.0)
	melee1.cardChance = 100
	melee1.cardsList = [load("res://Cards/Resources/dashCard.tres")]
	add_child(melee1)

func _on_level_1_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
