extends CharacterBody2D

const SPEED: int = 200
# const JUMP_POW: int = -250
var x_direction: int = 0
var y_direction: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if Input.is_action_pressed("Down"):
		y_direction = 1
	elif Input.is_action_pressed("Up"):
		y_direction = -1
	else:
		y_direction = 0
	
	if Input.is_action_pressed("Left"):
		x_direction = -1
	elif Input.is_action_pressed("Right"):
		x_direction = 1
	else:
		x_direction = 0
	
	velocity.x = x_direction * SPEED
	velocity.y = y_direction * SPEED
	
	move_and_slide()
