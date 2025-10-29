extends CharacterBody2D

var SPEED: int = 200
const JUMP_POW: int = -550
var x_direction: int = 0
var max_health: int = 100
var currHealth: int = 100

#stuff for dash
var canDash: bool = true
var dashCD: bool = false
var dashing: bool = false

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
		if not dashing:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0
	
	if is_on_floor():
		canDash = true
	
	if Input.is_action_pressed("Up") and is_on_floor():
		velocity.y += JUMP_POW
		
	#this should work even when you dont have power up, just like make canDash always false if you dont have it (so that you cant change direction while dashign)
	if not dashing:
		if Input.is_action_pressed("Left"):
			x_direction = -1
			$Sprite2D.play("walk")
		elif Input.is_action_pressed("Right"):
			x_direction = 1
			$Sprite2D.play("walk")
		else:
			x_direction = 0
			$Sprite2D.play("idle")
	
	
	#dash/attack
	if Input.is_action_pressed("Shoot"):
		if(not dashCD) and canDash:
			$dashtimer.start()
			$dashCooldown.start()
			dashing = true
			dashCD = true
			canDash = false
		
	if dashing:
		SPEED = 800
	else:
		SPEED = 200
	
	velocity.x = x_direction * SPEED
	
	move_and_slide()

func die():
	death.emit()
	queue_free()

func dmg(num: int):
	currHealth -= num
	health_Update()


#dash stuff
func _on_dashCooldown_timeout() -> void:
	dashCD = false

func _on_dashtimer_timeout() -> void:
	dashing = false
	pass # Replace with function body.
