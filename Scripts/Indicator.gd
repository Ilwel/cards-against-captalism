extends Node

@onready var animation_sprite = $AnimatedSprite2D
@export var animation = "noise"
@export var indicator_name = "Alienação"
@onready var indicator_name_lbl = $IndicatorNameLbl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_sprite.play(animation)
	indicator_name_lbl.text = indicator_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
