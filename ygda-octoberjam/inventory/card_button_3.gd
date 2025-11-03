@tool
extends Button

class_name CardButton

@export var card: Card :
	set(card_to_slot):
		card = card_to_slot
		icon = card.texture
