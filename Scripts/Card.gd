@tool
class_name Card extends Node2D

@export var card_name = "ace_hearts"
@onready var card_sprite = $Sprite2D

signal click

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_path = "res://Assets/Deck/%s.png"  % card_name
	card_sprite.texture = load(card_path)
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		click.emit()
