extends CharacterBody2D

const SPEED: int = 200
const JUMP_POW: int = -250
var x_direction: int = 0
var max_health: int = 100
var currHealth: int = 100

signal death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.max_value = max_health
	health_Update()

func health_Update() -> void:
	if currHealth == 0:
		die()
	else:
		$HealthBar.value = currHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("Up") and is_on_floor():
		velocity.y += JUMP_POW
	
	if Input.is_action_pressed("Left"):
		x_direction = -1
	elif Input.is_action_pressed("Right"):
		x_direction = 1
	else:
		x_direction = 0
	
	velocity.x = x_direction * SPEED
	
	move_and_slide()

func die():
	death.emit()
	queue_free()

func dmg(num: int):
	currHealth -= num
	health_Update()
