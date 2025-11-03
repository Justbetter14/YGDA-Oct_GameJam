extends Area2D

var speed: int = 225
@export var dmg: int = 100
var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = direction.rotated(deg_to_rad(-20))
	direction = direction.normalized()
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("enemyHit")
		body.takeDmg(10) # Destroy the enemy
		queue_free()
