extends CharacterBody2D

const SPEED: int = 25
var x_direction: int = 1
var dmg: int = 10
var player: CharacterBody2D = null

var canShoot: bool = true
var shouldMove: bool = true
var bulletScene = preload("res://enemy/projectile/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

# Called every frame. 'delta' i	s the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if shouldMove == true:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = SPEED * direction
		move_and_slide()
	else:
		if canShoot:
			shot()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = false
		if canShoot:
			shot()

func _on_bullet_cooldown_timeout() -> void:
	$"Bullet Cooldown".stop()
	canShoot = true

func shoot():
	var instance = bulletScene.instantiate()
	instance.global_position = $Marker2D.global_position
	instance.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(instance)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		shouldMove = true

func shot():
	shoot()
	$"Bullet Cooldown".start(5)
	canShoot = false
