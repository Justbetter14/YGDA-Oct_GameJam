extends Button

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

@export var card: Card :
	set(card_to_slot):
		card = card_to_slot
		icon = card.texture
		
var type: Card

func _ready():
	connect("pressed", on_pressed)

func on_pressed():
	player.currentCard = card
	
