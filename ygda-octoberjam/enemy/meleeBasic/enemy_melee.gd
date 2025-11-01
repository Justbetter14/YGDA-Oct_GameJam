extends CharacterBody2D

const SPEED: int = 25
var hp: int = 100
var x_direction: int = 1
var dmg: int = 10
var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp <= 0:
		queue_free()
	
	var direction = (player.global_position - global_position).normalized()
	
	velocity = SPEED * direction
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.dmg(dmg)

func takeDmg(num: int):
	hp -= num
