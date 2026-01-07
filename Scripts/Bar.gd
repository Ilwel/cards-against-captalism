@tool
extends Node2D

@export var progress = 10

@onready var bars: Array[Sprite2D] = [$BarNode/Bar1, $BarNode/Bar2, $BarNode/Bar3, $BarNode/Bar4, $BarNode/Bar5, $BarNode/Bar6, $BarNode/Bar7, $BarNode/Bar8, $BarNode/Bar9, $BarNode/Bar10]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress = Match.get_legitimacy()
	for i in range(10):
		if progress > i:
			bars[i].modulate =  Color("#a6e3a1")
		else:
			bars[i].modulate = Color("#f38ba8")
