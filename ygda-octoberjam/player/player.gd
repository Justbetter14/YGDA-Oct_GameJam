extends CharacterBody2D

var SPEED: int = 200
const JUMP_POW: int = -600
var x_direction: int = 0
var max_health: int = 100
var currHealth: int = 100
@export var healthbar : ProgressBar;
#stuff for dash
var canDash: bool = true
var dashCD: bool = false
var dashing: bool = false
var iframe: bool = false
var dir: String = 'right'
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

signal death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar.max_value = max_health
	health_Update()

func health_Update() -> void:
	if currHealth == 0:
		die()
	else:
		healthbar.value = currHealth

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
			dir = 'left'
			$Sprite2D.play('left')
		elif Input.is_action_pressed("Right"):
			x_direction = 1
			dir = 'right'
			$Sprite2D.play('right')
		else:
			x_direction = 0
			if(dir == 'left'):
				$Sprite2D.play('idleLeft')
			if(dir == 'right'):
				$Sprite2D.play('idleRight')			

	if dashing:
		if(dir == 'left'):
			$Sprite2D.play('dashLeft')
		if(dir == 'right'):
			$Sprite2D.play('dashRight')
	
	#dash/attack
	if Input.is_action_pressed("Dash"):
		if(not dashCD) and canDash:
			$dashTimer.start()
			$dashCooldown.start()
			dashing = true
			dashCD = true
			canDash = false
		
	if dashing:
		SPEED = 550
	else:
		SPEED = 200
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		velocity.x = x_direction * SPEED
	
	move_and_slide()

func die():
	death.emit()
	queue_free()

func dmg(num: int):
	if iframe == false:
		currHealth -= num
		health_Update()
		iframe = true
		$iFrame.start()

#dash stuffwd

func _on_dash_timer_timeout() -> void:
	dashing = false
	pass # Replace with function body.


func _on_dash_cooldown_timeout() -> void:
	dashCD = false
	pass # Replace with function body.


func _on_i_frame_timeout() -> void:
	iframe = false
	pass # Replace with function body.
	
func applyKnockback(direction: Vector2, force: float, knockbackDuration: float) -> void:
	print(iframe)
	if iframe == false:
		print('yay')
		knockback = direction*force
		knockback_timer = knockbackDuration
		dmg(10)
	
