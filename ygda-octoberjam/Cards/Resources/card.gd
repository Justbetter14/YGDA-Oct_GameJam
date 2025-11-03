extends Resource

class_name Card

@export var display_name : String
@export var texture : Texture2D
@export var cardType: String

# Movement Cards
@export var ableDash: bool
@export var ableDoubleJump: bool
@export var ableWallJump: bool

# Attack Cards
@export var ableFire: bool
@export var ableDagger: bool
@export var ableSword: bool
