extends CharacterBody2D

const SPEED: int = 35
var hp: int = 100
var x_direction: int = 1
var dmg: int = 10
var player: CharacterBody2D = null

var canBite: bool = true
var shouldMove: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp <= 0:
		queue_free()
	for body in $"Hit Box Area".get_overlapping_bodies():
		if body.is_in_group("player"):
			var knockbackDirection = (player.global_position - global_position).normalized()
			player.applyKnockback(knockbackDirection, 300, 0.2, dmg)			
	if shouldMove == true:
		var direction = (player.global_position - global_position).normalized()
		velocity = SPEED * direction
		move_and_slide()
		$Sprite2D.play("Idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false
		$Sprite2D.play("Bite1")
		await $Sprite2D.animation_finished
		$Sprite2D.play("Bite2")
		#$attackTimer.start()
		if body.is_in_group("player"):
			if canBite:
				bite()
				shouldMove = true
				$"Attack Cooldown".start()

func takeDmg(num: int):
	hp -= num
	if hp <= 0:
		queue_free()

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

#func _on_hit_box_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#var knockbackDirection = (body.global_position - global_position).normalized()
		#body.applyKnockback(knockbackDirection, 150.0, 0.2, dmg)

func _on_attack_timer_timeout() -> void:
	for body in $"Attack Area".get_overlapping_bodies():
		if body.is_in_group("player"):
			if canBite:
				bite()
				shouldMove = true
				$"Attack Cooldown".start()
