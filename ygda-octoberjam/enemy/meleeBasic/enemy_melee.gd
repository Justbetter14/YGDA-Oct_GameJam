extends CharacterBody2D

const SPEED: int = 25
var hp: int = 100
var x_direction: int = 1
var dmg: int = 10
var player: CharacterBody2D = null

var canBite: bool = true
var shouldMove: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp <= 0:
		queue_free()
	if shouldMove == true:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = SPEED * direction
		move_and_slide()
	else:
		if canBite:
			bite()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false
		if canBite:
			bite()

func takeDmg(num: int):
	hp -= num

func bite():
	player.dmg(dmg)
	
func _on_attack_cooldown_timeout() -> void:
	$"Bullet Cooldown".stop()
	canBite = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = true
