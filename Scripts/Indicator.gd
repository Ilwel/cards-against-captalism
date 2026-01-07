extends Node

@onready var animation_sprite = $AnimatedSprite2D
@export var animation = "noise"
@export var indicator_name = "Alienação"
@onready var indicator_name_lbl = $IndicatorNameLbl
@onready var value_lbl = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_sprite.play(animation)
	indicator_name_lbl.text = indicator_name



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animation == "noise":
		value_lbl.text  = str(Match.get_alienation())
	elif animation == "gear":
		value_lbl.text  = str(Match.get_exploitation())
	elif animation == "coin":
		value_lbl.text  = str(Match.get_capital())
		
