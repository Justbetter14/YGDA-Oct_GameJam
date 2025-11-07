extends AnimatedSprite2D

var speed: int = 200
var direction: Vector2 = Vector2.ZERO
var dmg: int = 10
var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play("spin")
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var knockbackDirection = (player.global_position - global_position).normalized()
		player.applyKnockback(knockbackDirection, 150.0, 0.2, dmg)
		queue_free()
