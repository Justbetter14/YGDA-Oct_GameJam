@tool
extends Button

class_name CardButton


@export var card: Card :
	set(card_to_slot):
		card = card_to_slot
		icon = card.texture
		
var type: Card

func _ready():
	connect("pressed", on_pressed)

func on_pressed():
	type = card
	
