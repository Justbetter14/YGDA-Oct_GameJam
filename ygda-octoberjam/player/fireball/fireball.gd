extends Area2D

class_name Fireball

var speed: int = 200
@export var dmg: int = 75
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == Vector2.ZERO:
		queue_free()
	direction = direction.normalized()
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	$AnimatedSprite2D.play("default")
	position += speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func aoe():
	for area2 in $AOE.get_overlapping_areas():
		if area2.is_in_group("enemy"):
			print("enemyHit")
			area2.takeDmg(10) # Destroy the enemy
	queue_free()
