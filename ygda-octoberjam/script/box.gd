extends RigidBody2D

var inContact = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	inContact = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	inContact = true

func _process(delta):
	if(not inContact):
		self.linear_velocity = Vector2.ZERO
		self.angular_velocity = 0
