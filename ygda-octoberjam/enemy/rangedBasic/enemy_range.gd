extends CharacterBody2D

const SPEED: int = 25
var x_direction: int = 1
var hp: int = 100
var dmg: int = 10
var player: CharacterBody2D = null

var canShoot: bool = true
var shouldMove: bool = true
var bulletScene = preload("res://enemy/projectile/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if hp <= 0:
		queue_free()
	if shouldMove == true:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = SPEED * direction
		move_and_slide()
	else:
		if canShoot:
			shot()
		

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false
		if canShoot:
			shot()

func _on_bullet_cooldown_timeout() -> void:
	canShoot = true

func shoot():
	var instance = bulletScene.instantiate()
	instance.global_position = $Marker2D.global_position
	instance.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(instance)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = true

func shot():
	shoot()
	$"Bullet Cooldown".start()
	canShoot = false

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
			area.queue_free()
		if area is Dagger0 or area is Dagger1 or area is Dagger2:
			print("Dagger Hit")
			area.queue_free()
		takeDmg(area.dmg)
