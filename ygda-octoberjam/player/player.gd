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
const emptyCard = preload("res://Cards/Resources/emptyCard.tres")
var CurrentMove: Card
var CurrentAttack: Card

# Dash
var canDash: bool = false
var ableDash: bool = false
var dashCD: bool = false
var dashing: bool = false

# Double Jump
var canDoubleJump: bool = false
var jumpCount: int = 0

# Wall Jump
var canWallJump: bool = false

# Fireball
var canFire: bool = false
const fireball = preload("res://player/fireball/fireball.tscn")

# Dagger / Ghostly Darts
var canDagger: bool = false
const daggerZero = preload("res://player/dagger/daggerStraight.tscn")
const daggerPos = preload("res://player/dagger/daggerPos.tscn")
const daggerNeg = preload("res://player/dagger/daggerNeg.tscn")

# Sword
var canSword: bool = false

signal death

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

func _physics_process(delta: float) -> void:
	gravityCooldown(delta)
	
	
	animation()
	
	doubleJump()
	dash()
	wallJump()
	
	knockBack(delta)
	
	fireBall()
	dagger()
	
	cardDetect()
	pickupCard()
	
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
	iframe = false
	if(currentCard):
		print(currentCard.display_name)
	pass # Replace with function body.

func _on_dash_cooldown_timeout() -> void:
	dashCD = false
	pass # Replace with function body.

func _on_i_frame_timeout() -> void:
	iframe = false
	pass # Replace with function body.

func applyKnockback(direction: Vector2, force: float, knockbackDuration: float, damage: int) -> void:
	print(iframe)
	if iframe == false:
		print('yay')
		knockback = direction*force
		knockback_timer = knockbackDuration
		dmg(damage)

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
		if (not dashCD) and ableDash and canDash:
			$dashTimer.start()
			$dashCooldown.start()
			iframe = true
			dashing = true
			dashCD = true
			ableDash = false
		
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
			velocity += get_gravity() * delta * 1.5
		else:
			velocity.y = 0
	
	if is_on_floor():
		ableDash = true
		jumpCount = 0

func fireBall():
	if Input.is_action_pressed("Attack") and $"fireball Cooldown".is_stopped() and canFire: # Check if player cooldown is over
		$"fireball Cooldown".start()
		var fire: Area2D = fireball.instantiate()
		fire.position = position
		
		var Fdirection = Vector2.ZERO
		
		if Input.is_action_pressed("Right"):
			if Input.is_action_pressed("Aiming Up"):
				Fdirection = Vector2.RIGHT.rotated(deg_to_rad(-45))
			elif Input.is_action_pressed("Aiming Down"):
				Fdirection = Vector2.RIGHT.rotated(deg_to_rad(+45))
			else:
				Fdirection = Vector2.RIGHT
		elif Input.is_action_pressed("Left"):
			if Input.is_action_pressed("Aiming Up"):
				Fdirection = Vector2.LEFT.rotated(deg_to_rad(+45))
			elif Input.is_action_pressed("Aiming Down"):
				Fdirection = Vector2.LEFT.rotated(deg_to_rad(-45))
			else:
				Fdirection = Vector2.LEFT
		elif Input.is_action_pressed("Aiming Up"):
			Fdirection = Vector2.UP
		elif Input.is_action_pressed("Aiming Down"):
			Fdirection = Vector2.DOWN
		
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
		
		var Ddirection = Vector2.ZERO
		
		if Input.is_action_pressed("Right"):
			if Input.is_action_pressed("Aiming Up"):
				Ddirection = Vector2.RIGHT.rotated(deg_to_rad(-45))
			elif Input.is_action_pressed("Aiming Down"):
				Ddirection = Vector2.RIGHT.rotated(deg_to_rad(+45))
			else:
				Ddirection = Vector2.RIGHT
		elif Input.is_action_pressed("Left"):
			if Input.is_action_pressed("Aiming Up"):
				Ddirection = Vector2.LEFT.rotated(deg_to_rad(+45))
			elif Input.is_action_pressed("Aiming Down"):
				Ddirection = Vector2.LEFT.rotated(deg_to_rad(-45))
			else:
				Ddirection = Vector2.LEFT
		elif Input.is_action_pressed("Aiming Up"):
			Ddirection = Vector2.UP
		elif Input.is_action_pressed("Aiming Down"):
			Ddirection = Vector2.DOWN
		
		dag0.direction = Ddirection
		dagPos1.direction = Ddirection
		dagNeg1.direction = Ddirection
		
		get_tree().current_scene.add_child(dag0)
		get_tree().current_scene.add_child(dagPos1)
		get_tree().current_scene.add_child(dagNeg1)

func cardDetect():
	var currentButton1: Button = $"../CanvasLayer/Inventory/GridContainer/cardButton1"
	var currentButton2: Button = $"../CanvasLayer/Inventory/GridContainer/cardButton2"
	var currentButton3: Button = $"../CanvasLayer/Inventory/GridContainer/cardButton3"
	
	if Input.is_action_pressed("Hotkey 1"):
		if currentButton1.icon != emptyCard.texture:
			useCard(currentButton1)
	if Input.is_action_pressed("Hotkey 2"):
		if currentButton2.icon != emptyCard.texture:
			useCard(currentButton2)
	if Input.is_action_pressed("Hotkey 3"):
		if currentButton3.icon != emptyCard.texture:
			useCard(currentButton3)

func useCard(currentButton: Button):
	var type: Card
	var cardsList = [preload("res://Cards/Resources/daggerCard.tres"), preload("res://Cards/Resources/dashCard.tres"), preload("res://Cards/Resources/fireballCard.tres"), preload("res://Cards/Resources/swordCard.tres")]
	for card in cardsList:
		if card.texture == currentButton.icon:
			type = card
	if type.cardType == 'attack':
		CurrentAttack = type
		canFire = CurrentAttack.ableFire
		canDagger = CurrentAttack.ableDagger
		canSword = CurrentAttack.ableSword
		print(CurrentAttack.display_name)
	if type.cardType == 'movement':
		CurrentMove = type
		canDash = CurrentMove.ableDash
		canDoubleJump = CurrentMove.ableDoubleJump
		canWallJump = CurrentMove.ableWallJump
		print(CurrentMove.display_name)

	currentButton.icon = emptyCard.texture

func pickupCard():
	var currentButton: Button = null
	if emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton1".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton1"
	elif emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton2".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton2"
	elif emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton3".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton3"
	
	if currentButton != null:
		if Input.is_action_just_pressed("Select"):
			currentCard = load("res://Cards/Resources/swordCard.tres")
			currentButton.icon = currentCard.texture
