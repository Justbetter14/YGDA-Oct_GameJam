extends Node2D

var basicEnemy = preload("res://enemy/meleeBasic/enemy_melee.tscn")
var basicExplode = preload("res://enemy/destructEnemy/EnemyExplode.tscn")
var basicRange = preload("res://enemy/rangedBasic/enemy_range.tscn")

func _ready() -> void:
	$Checkpoint.global_position = $Player.global_position + Vector2(0, -7)
	var explode1 = basicExplode.instantiate()
	var explode2 = basicExplode.instantiate()
	var explode3 = basicExplode.instantiate()
	var explode4 = basicExplode.instantiate()
	var explode5 = basicExplode.instantiate()
	var explode6 = basicExplode.instantiate()
	explode1.global_position = Vector2(1167, -760)
	explode2.global_position = Vector2(1333, -840)
	explode3.global_position = Vector2(1500, -1000)
	explode4.global_position = Vector2(-200, -400)
	explode5.global_position = Vector2(400, -840)
	explode6.global_position = Vector2(-300, -850)
	add_child(explode1)
	add_child(explode2)
	add_child(explode3)
	add_child(explode4)
	add_child(explode5)
	add_child(explode6)

func _process(delta: float) -> void:
	$Checkpoint.play("default")

func _on_player_death() -> void:
	get_parent().death()
	pass # Replace with function body.

func _on_level_13_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().nextLevel()
		queue_free()
