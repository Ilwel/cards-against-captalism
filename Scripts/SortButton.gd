extends Node

enum SortType {
	Suit,
	Rank
}
@export var type: SortType = SortType.Suit
@export var hand:Hand

@onready var sprite = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == SortType.Suit:
		sprite.texture = load("res://Assets/SuitsSortButton.png")
	elif type == SortType.Rank:
		sprite.texture = load("res://Assets/RankSortButton.png")


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if type == SortType.Suit:
			hand.sort_hand_suits()
		elif type == SortType.Rank:
			hand.sort_hand_rank()
