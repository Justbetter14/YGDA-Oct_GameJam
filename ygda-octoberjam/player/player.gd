extends CharacterBody2D

signal death

#region Jump & Speed Varsd
var SPEED: int = 250
var maxSpeed: int = 250
var dashSpeed: int = 550
const JUMP_POW: int = -650
var x_direction: int = 0
var dir: String = 'right'
#endregion

#region Health Vars
var max_health: int = 100
var currHealth: int = 100
@export var healthbar : ProgressBar;
var isDead: bool = false
#endregion

#region Card Variables
@export var currentCard : Card
var CurrentMove: Card
var CurrentAttack: Card

const emptyCard: Card = preload("res://Cards/Resources/emptyCard.tres")
const daggerCard: Card = preload("res://Cards/Resources/daggerCard.tres")
const dashCard: Card = preload("res://Cards/Resources/dashCard.tres")
const fireCard: Card = preload("res://Cards/Resources/fireballCard.tres")
const swordCard: Card = preload("res://Cards/Resources/swordCard.tres")
const doublejumpCard: Card = preload("res://Cards/Resources/doublejumpCard.tres")
const walljumpCard: Card = preload("res://Cards/Resources/walljumpCard.tres")
#endregion

#region Movement Variables
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
#endregion

#region Attack Variables
# Basic
var canBasic: bool = true
var ableBasic: bool = true

# Fireball
var canFire: bool = false
const fireball := preload("res://player/fireball/fireball.tscn")

# Dagger / Ghostly Darts
var canDagger: bool = false
const daggerZero := preload("res://player/dagger/daggerStraight.tscn")
const daggerPos := preload("res://player/dagger/daggerPos.tscn")
const daggerNeg := preload("res://player/dagger/daggerNeg.tscn")

# Sword
var canSword: bool = false
var ableSword: bool = true
@export var Strength: int = 100
#endregion

#region Collision Variables
var iframe: bool = false
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
#endregion

func _ready() -> void:
	healthbar.max_value = max_health
	print(healthbar.max_value)
	health_Update()

func _physics_process(delta: float) -> void:
	gravityCooldown(delta)
	
	animation()
	
	doubleJump()
	dash()
	wallJump()
	
	knockBack(delta)
	
	basic()
	fireBall()
	dagger()
	sword()
	
	cardDetect()
	
	move_and_slide()

#region Health & Death Functions
func health_Update() -> void:
	if currHealth <= 0:
		healthbar.value = currHealth
		die()
	else:
		healthbar.value = currHealth
		print(healthbar.value)

func die():
	if not isDead:
		isDead = true
		death.emit()
		queue_free()

func dmg(num: int):
	print('triggered')
	if iframe == false:
		currHealth -= num
		health_Update()
		iframe = true
		$iFrame.start()
#endregion

#region Collision & Forces Functions
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

func knockBack(delta: float):
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		velocity.x = x_direction * SPEED

func gravityCooldown(delta: float):
	if not is_on_floor():
		if not dashing:
			velocity += get_gravity() * delta * 1.5
		else:
			velocity.y = 0
	
	if is_on_floor():
		ableDash = true
		jumpCount = 0
#endregion

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

#region Movement Functions
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
		SPEED = dashSpeed
	else:
		SPEED = maxSpeed

func _on_dash_timer_timeout() -> void:
	dashing = false
	iframe = false
	if(currentCard):
		print(currentCard.display_name)
	pass # Replace with function body.

func _on_dash_cooldown_timeout() -> void:
	dashCD = false
	pass # Replace with function body.
#endregion

#region Attack Functions
func basic():
	if canBasic == false:
		return
	if ableBasic == false:
		return
	
	if Input.is_action_pressed("Attack") and $"basic Cooldown".is_stopped() and canBasic and ableBasic:
		$"basic Cooldown".start()
		ableBasic = false
		print("Attack /w basic")
		if dir == 'right':
			print("Bsaic Right")
			rightSlash()
		elif dir == 'left':
			print("bsaic Left")
			leftSlash()
		ableBasic = true

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
		
		if Fdirection == Vector2.ZERO:
			if dir == 'right':
				Fdirection = Vector2.RIGHT
			elif dir == 'left':
				Fdirection = Vector2.LEFT
		
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
		
		if Ddirection == Vector2.ZERO:
			if dir == 'right':
				Ddirection = Vector2.RIGHT
			elif dir == 'left':
				Ddirection = Vector2.LEFT
		
		dag0.direction = Ddirection
		dagPos1.direction = Ddirection
		dagNeg1.direction = Ddirection
		
		get_tree().current_scene.add_child(dag0)
		get_tree().current_scene.add_child(dagPos1)
		get_tree().current_scene.add_child(dagNeg1)

func sword():
	if canSword == false:
		return
	if ableSword == false:
		return
	
	if Input.is_action_pressed("Attack") and $"sword Cooldown".is_stopped():
		$"sword Cooldown".start()
		ableSword = false
		print("Attack /w swordddd")
		
		if dir == 'right':
			print("Sowrdd Right")
			#$Sprite2D.play("swordSlash")
			#await $Sprite2D.animation_finished
			rightSlash()
		elif dir == 'left':
			print("Sowrdd Left")
			#$Sprite2D.play("swordSlash")
			#await $Sprite2D.animation_finished
			leftSlash()
		
		ableSword = true

func rightSlash():
	$"Right Slash".monitoring = true
	$"Right Slash".monitorable = true
	#$Sprite2D.flip_h = false
	await get_tree().create_timer(0.2).timeout
	#$Sprite2D.play("swordSlash")
	#await $Sprite2D.animation_finished
	$"Right Slash".monitoring = false
	$"Right Slash".monitorable = false

func leftSlash():
	$"Left Slash".monitoring = true
	$"Left Slash".monitorable = true
	$Sprite2D.flip_h = true
	$Sprite2D.flip_h = false
	await get_tree().create_timer(0.2).timeout
	$"Left Slash".monitoring = false
	$"Left Slash".monitorable = false
#endregion

#region Card Functions
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
	var cardsList = [daggerCard, dashCard, fireCard, swordCard, doublejumpCard, walljumpCard]
	for card in cardsList:
		if card.texture == currentButton.icon:
			type = card
	
	match type.cardType:
		'attack':
			CurrentAttack = type
			canBasic = false
			canFire = CurrentAttack.ableFire
			canDagger = CurrentAttack.ableDagger
			canSword = CurrentAttack.ableSword
			print(CurrentAttack.display_name)
		'movement':
			CurrentMove = type
			canDash = CurrentMove.ableDash
			canDoubleJump = CurrentMove.ableDoubleJump
			canWallJump = CurrentMove.ableWallJump
			print(CurrentMove.display_name)

	currentButton.icon = emptyCard.texture

func _on_pick_up_radius_area_entered(area: Area2D) -> void:
	if not area.is_in_group("cards"):
		return
	
	var currentButton: Button = null
	if emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton1".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton1"
	elif emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton2".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton2"
	elif emptyCard.texture == $"../CanvasLayer/Inventory/GridContainer/cardButton3".icon:
		currentButton = $"../CanvasLayer/Inventory/GridContainer/cardButton3"
	
	if currentButton == null:
		return
	
	var texture = area.get_parent().card.texture
	if texture != null:
		currentButton.icon = texture
		area.get_parent().queue_free()
#endregion
