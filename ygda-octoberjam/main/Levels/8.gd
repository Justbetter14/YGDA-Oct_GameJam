extends Node2D

var basicEnemy = preload("res://enemy/meleeBasic/enemy_melee.tscn")
var basicExplode = preload("res://enemy/destructEnemy/EnemyExplode.tscn")
var basicRange = preload("res://enemy/rangedBasic/enemy_range.tscn")

func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	var melee1 = basicEnemy.instantiate()
	var melee2 = basicEnemy.instantiate()
	var melee3 = basicEnemy.instantiate()
	var melee4 = basicEnemy.instantiate()
	var melee5 = basicEnemy.instantiate()
	var range1 = basicRange.instantiate()
	var range2 = basicRange.instantiate()
	var explode1 = basicExplode.instantiate()
	var explode2 = basicExplode.instantiate()
	var explode3 = basicExplode.instantiate()
	melee1.global_position = Vector2(0, -200)
	melee2.global_position = Vector2(167, -280)
	melee3.global_position = Vector2(333, -360)
	melee4.global_position = Vector2(500, -440)
	melee5.global_position = Vector2(667, -520)
	range1.global_position = Vector2(833, -600)
	range2.global_position = Vector2(1000, -680)
	explode1.global_position = Vector2(1167, -760)
	explode2.global_position = Vector2(1333, -840)
	explode3.global_position = Vector2(1500, -1000)
	add_child(melee1)
	add_child(melee2)
	add_child(melee3)
	add_child(melee4)
	add_child(melee5)
	add_child(range1)
	add_child(range2)
	add_child(explode1)
	add_child(explode2)
	add_child(explode3)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.


func _on_level_12_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()
