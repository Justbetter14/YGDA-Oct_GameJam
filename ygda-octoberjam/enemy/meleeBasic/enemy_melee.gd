extends CharacterBody2D

var hp: int = 100
var player: CharacterBody2D = null

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

#region Movement Variables
const SPEED: int = 35
var x_direction: int = 1
var shouldMove: bool = true
#endregion

#region Damage Variables
var dmg: int = 10
var canBite: bool = true
#endregion

func _ready():
	player = get_parent().get_node("Player")
	randomize()

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		die()
	if shouldMove == true:
		var direction = (player.global_position - global_position).normalized()
		velocity = SPEED * direction
		move_and_slide()
		$Sprite2D.play("Idle")

#region Attack & Movement Functions
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false
		$Sprite2D.play("Bite1")
		await $Sprite2D.animation_finished
		$Sprite2D.play("Bite2")
		#$attackTimer.start()
		if canBite:
			bite()
			shouldMove = true
			$"Attack Cooldown".start()

func bite():
	#player.dmg(dmg)
	var knockbackDirection = (player.global_position - global_position).normalized()
	player.applyKnockback(knockbackDirection, 400, 0.2, dmg)
	$Sprite2D.play("Idle")

func _on_attack_cooldown_timeout() -> void:
	$"Attack Cooldown".stop()
	canBite = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = true

func _on_attack_timer_timeout() -> void:
	for body in $"Attack Area".get_overlapping_bodies():
		if body.is_in_group("player"):
			shouldMove = false
			$Sprite2D.play("Bite1")
			await $Sprite2D.animation_finished
			$Sprite2D.play("Bite2")
			if canBite:
				bite()
				shouldMove = true
				$"Attack Cooldown".start()
#endregion

#region Hurt & Collision Functions
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
	print("Oh No I been Hit! * Dun Dun DUN *")
	if hp <= 0:
		die()

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
