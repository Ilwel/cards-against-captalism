@tool
class_name Card extends Node2D

@export var card_name = "ace_hearts"
@onready var card_sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_path = "res://Assets/Deck/%s.png"  % card_name
	card_sprite.texture = load(card_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
