extends Area2D

var speed: int = 225
@export var dmg: int = 100
var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = direction.normalized()
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	$AnimatedSprite2D.play("default")
	position += speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: CharacterBody2D) -> void:
	for body2 in $AOE.get_overlapping_bodies():
		if body2.is_in_group("enemy"):
			print("enemyHit")
			body2.takeDmg(10) # Destroy the enemy
			queue_free()
