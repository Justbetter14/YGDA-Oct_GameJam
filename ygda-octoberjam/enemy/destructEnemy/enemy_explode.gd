extends CharacterBody2D

@export var hp: int = 100
var player: CharacterBody2D = null

#region Card Variables
@export var cardChance: int = 50
var cardScene = preload("res://Cards/Resources/cards.tscn")
const daggerCard: Card = preload("res://Cards/Resources/daggerCard.tres")
const dashCard: Card = preload("res://Cards/Resources/dashCard.tres")
const fireCard: Card = preload("res://Cards/Resources/fireballCard.tres")
const swordCard: Card = preload("res://Cards/Resources/swordCard.tres")
const doublejumpCard: Card = preload("res://Cards/Resources/doublejumpCard.tres")
const walljumpCard: Card = preload("res://Cards/Resources/walljumpCard.tres")
@export var cardsList = [daggerCard, dashCard, fireCard, swordCard, doublejumpCard, walljumpCard]
var cardGiven: bool = false
#endregion

#region Movement Variables
const SPEED: int = 35
var x_direction: int = 1
var shouldMove: bool = true
#endregion

#region Damage Variables
@export var dmg: int = 25
var hasExploded: bool = false
#endregion

func _ready() -> void:
	player = get_parent().get_node("Player")
	randomize()

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()
	if shouldMove:
		$Sprite2D.play("default")
		var direction = (player.global_position - global_position).normalized()
		velocity = SPEED * direction
		move_and_slide()

#region Collision & Hurt Functions
func _on_hit_box_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		print("Print Projectivle Contatatstc")
		if area is Fireball:
			print("Fire Hit")
			area.aoe()
			takeDmg(area.dmg)
		if area is Dagger0 or area is Dagger1 or area is Dagger2:
			print("Dagger Hit")
			area.queue_free()
			takeDmg(area.dmg)
		else:
			print("Sword")
			takeDmg(player.Strength)

func _on_hit_box_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var knockbackDirection = (player.global_position - global_position).normalized()
		player.applyKnockback(knockbackDirection, 300, 0.2, dmg)

func takeDmg(num: int):
	hp -= num
	print("sad no explodey")
	if hp <= 0:
		die()

func die():
	$"Explosion Area".monitoring = true
	shouldMove = false
	print("Dead Check")
	await get_tree().process_frame
	if player in $"Explosion Area".get_overlapping_bodies():
		print("Explosion after Death Check")
		if hasExploded == false:
			var knockbackDirection = (player.global_position - global_position).normalized()
			player.applyKnockback(knockbackDirection, 600, 0.3, dmg)
			print("Exploded After Death")
			SoundEffects.play_sfx("enemy")
	print("Died")
	cardDraw(global_position)
	if hasExploded:
		queue_free()

func cardDraw(pos: Vector2):
	if cardGiven:
		return
	
	var randInt = randi() % 100
	
	if randInt > cardChance:
		return
	
	if not cardsList:
		cardsList = [daggerCard, dashCard, fireCard, swordCard, doublejumpCard, walljumpCard]
	var card = cardsList.pick_random()
	
	var instance = cardScene.instantiate()
	instance.card = card
	instance.global_position = pos
	get_parent().add_child(instance)
	
	cardGiven = true
#endregion

#region Attack Functions
func _on_explosion_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Startup.start()
		shouldMove = false

func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var knockbackDirection = (player.global_position - global_position).normalized()
		player.applyKnockback(knockbackDirection, 600, 0.3, dmg)
		SoundEffects.play_sfx("enemy")
		hasExploded = true
		print("Yippee")
		die()

func _on_startup_timeout() -> void:
	if player in $"Explosion Detection".get_overlapping_bodies():
		$"Explosion Area".monitoring = true
	else:
		shouldMove = true
		$"Explosion Area".monitoring = false
#endregion
