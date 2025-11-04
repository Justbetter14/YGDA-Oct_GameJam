extends CharacterBody2D

var hp: int = 100
var player: CharacterBody2D = null

#region Movement Variables
const SPEED: int = 25
var x_direction: int = 1
var shouldMove: bool = true
var shouldRun: bool = false
#endregion

#region Attack Variables
var canShoot: bool = true
var dmg: int = 10
var bulletScene = preload("res://enemy/projectile/bullet.tscn")
#endregion

#region Card Variables
@export var cardChance: int = 33
var cardScene = preload("res://Cards/Resources/cards.tscn")
const daggerCard: Card = preload("res://Cards/Resources/daggerCard.tres")
const dashCard: Card = preload("res://Cards/Resources/dashCard.tres")
const fireCard: Card = preload("res://Cards/Resources/fireballCard.tres")
const swordCard: Card = preload("res://Cards/Resources/swordCard.tres")
@export var cardsList = [daggerCard, dashCard, fireCard, swordCard]
var cardGiven: bool = false
#endregion

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()
	
	if shouldMove:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = SPEED * direction
		move_and_slide()
		
	elif shouldRun:
		var direction = (global_position - player.global_position).normalized()
		
		velocity = SPEED * direction
		move_and_slide()
		
	else:
		if canShoot:
			shoot()

#region Attack Functions
func _on_bullet_cooldown_timeout() -> void:
	canShoot = true

func shoot():
	var instance = bulletScene.instantiate()
	instance.global_position = $Marker2D.global_position
	instance.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(instance)
	$"Bullet Cooldown".start()
	canShoot = false
#endregion

#region Movement Functions
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = true

func _on_run_away_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldRun = true

func _on_run_away_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldRun = false
#endregion

#region Hurt & Collision Functions
func takeDmg(num: int):
	hp -= num

func _on_hit_box_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var knockbackDirection = (body.global_position - global_position).normalized()
		body.applyKnockback(knockbackDirection, 150.0, 0.2, dmg)

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

func die():
	cardDraw(global_position)
	queue_free()
#endregion

func cardDraw(pos: Vector2):
	if cardGiven:
		return
	
	var randInt = randi() % 100
	
	if randInt > cardChance:
		return
	
	var card = cardsList.pick_random()
	
	var instance = cardScene.instantiate()
	instance.card = card
	instance.global_position = pos
	get_parent().add_child(instance)
	
	cardGiven = true
