extends CharacterBody2D

const SPEED: int = 50
var x_direction: int = 1
var dmg: int = 25
var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	
	velocity = SPEED * direction
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.dmg(dmg)
