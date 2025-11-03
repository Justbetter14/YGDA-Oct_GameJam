extends CharacterBody2D

# Jump & Speed Related
var SPEED: int = 250
const JUMP_POW: int = -600
var x_direction: int = 0

# Health Related
var max_health: int = 100
var currHealth: int = 100
@export var healthbar : ProgressBar;

var iframe: bool = false
var dir: String = 'right'
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@export var currentCard : Card



# Dash
var canDash: bool = true
var dashCD: bool = false
var dashing: bool = false

# Double Jump
var canDoubleJump: bool = true
var jumpCount: int = 0

# Wall Jump
var canWallJump: bool = true

# Fireball
var canFire: bool = true
const fireball = preload("res://player/fireball/fireball.tscn")

# Dagger / Ghostly Darts
var canDagger: bool = true
const daggerZero = preload("res://player/dagger/daggerStraight.tscn")
const daggerPos = preload("res://player/dagger/daggerPos.tscn")
const daggerNeg = preload("res://player/dagger/daggerNeg.tscn")

# Sword
var canSword: bool = false

signal death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar.max_value = max_health
	print(healthbar.max_value)
	health_Update()

func health_Update() -> void:
	if currHealth <= 0:
		healthbar.value = currHealth
		die()
	else:
		healthbar.value = currHealth
		print(healthbar.value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	gravityCooldown(delta)
	
	
	animation()
	
	doubleJump()
	dash()
	wallJump()
	
	knockBack(delta)
	
	fireBall()
	dagger()
	
	move_and_slide()

func die():
	death.emit()
	queue_free()

func dmg(num: int):
	print('triggered')
	if iframe == false:
		currHealth -= num
		health_Update()
		iframe = true
		$iFrame.start()

func _on_dash_timer_timeout() -> void:
	dashing = false
	if(currentCard):
		print(currentCard.display_name)
	pass # Replace with function body.

func _on_dash_cooldown_timeout() -> void:
	dashCD = false
	pass # Replace with function body.

func _on_i_frame_timeout() -> void:
	iframe = false
	pass # Replace with function body.

func applyKnockback(direction: Vector2, force: float, knockbackDuration: float, dmg: int) -> void:
	print(iframe)
	if iframe == false:
		print('yay')
		knockback = direction*force
		knockback_timer = knockbackDuration
		dmg(dmg)

func doubleJump():
	if Input.is_action_just_pressed("Up") and (is_on_floor() or (canDoubleJump == true and jumpCount < 2)):
		print(jumpCount)
		jumpCount += 1
		velocity.y = JUMP_POW
	elif velocity.y < 0.0 and Input.is_action_just_released("Up"):
		velocity.y *= 0.2

func wallJump():
	if Input.is_action_just_pressed("Up") and is_on_wall() and canWallJump == true:
			if Input.is_action_pressed("Right"):
				print("wall jumped right")
				velocity.y = JUMP_POW
				velocity.x = -200
			if Input.is_action_pressed("Left"):
				print("wall jumped left")
				velocity.y = JUMP_POW
				velocity.x = 200

func dash():
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

func knockBack(delta: float):
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		velocity.x = x_direction * SPEED

func animation():
	if not dashing:
		if Input.is_action_pressed("Left"):
			x_direction = -1
			dir = 'left'
			if(is_on_floor()):
				$Sprite2D.play('left')
			elif(true):
				if(Input.is_action_just_pressed("Up")):
					$Sprite2D.play("jumpLeft")
					print('jumpAnimationTriggered')
					await $Sprite2D.animation_finished
				elif(velocity.y <=0.0):
					$Sprite2D.play('goingUpLeft')
				else:	
					$Sprite2D.play('fallLeft')
		elif Input.is_action_pressed("Right"):
			x_direction = 1
			dir = 'right'
			if(is_on_floor()):
				$Sprite2D.play('right')
			elif(true):
				if(Input.is_action_just_pressed("Up")):
					$Sprite2D.play("jumpRight")
					print('jumpAnimationTriggered')
					await $Sprite2D.animation_finished
				elif(velocity.y <=0.0):
					$Sprite2D.play('goingUpRight')
				else:
					$Sprite2D.play('fallRight')
				
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

func gravityCooldown(delta: float):
	if not is_on_floor():
		if not dashing:
			velocity += get_gravity() * delta
		else:
			velocity.y = 0
	
	if is_on_floor():
		canDash = true
		jumpCount = 0

func fireBall():
	if Input.is_action_pressed("Attack") and $"fireball Cooldown".is_stopped() and canFire: # Check if player cooldown is over
		$"fireball Cooldown".start()
		var fire: Area2D = fireball.instantiate()
		fire.position = position
		
		var target = get_global_mouse_position()
		var Fdirection = (target - global_position).normalized()
		
		fire.direction = Fdirection
		
		get_tree().current_scene.add_child(fire)

func dagger():
	if Input.is_action_pressed("Attack") and $"dagger Cooldown".is_stopped() and canDagger:
		$"dagger Cooldown".start()
		var dag0: Area2D = daggerZero.instantiate()
		dag0.position = position
		var dagPos1: Area2D = daggerPos.instantiate()
		dagPos1.position = position
		var dagNeg1: Area2D = daggerNeg.instantiate()
		dagNeg1.position = position
		
		var target = get_global_mouse_position()
		var Ddirection = (target - global_position).normalized()
		
		dag0.direction = Ddirection
		dagPos1.direction = Ddirection
		dagNeg1.direction = Ddirection
		
		get_tree().current_scene.add_child(dag0)
		get_tree().current_scene.add_child(dagPos1)
		get_tree().current_scene.add_child(dagNeg1)
