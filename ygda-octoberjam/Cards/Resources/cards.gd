extends Node2D

@export var card: Card = preload("res://Cards/Resources/emptyCard.tres")

func _ready() -> void:
	$Sprite2D.texture = card.texture
