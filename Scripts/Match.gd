@tool
extends Node2D

@onready var match_state = {
	"exploitation":10,
	"alienation":10,
	"capital":10,
	"legitimacy":10,
	"player_deck": []
}

func load_player_deck(path:String = "res://Assets/DataDecks/player_deck.json")->void:
	var file = FileAccess.open(path,FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	match_state.player_deck = data.deck.duplicate()

func get_player_deck() -> Array:
	return match_state.player_deck

func get_exploitation()->int:
	return match_state.exploitation

func set_exploitation(v:int)->void:
	match_state.exploitation = max(v,0)
	update_legitimacy()

func get_alienation()->int:
	return match_state.alienation

func set_alienation(v:int)->void:
	match_state.alienation = max(v,0)
	update_legitimacy()

func get_capital()->int:
	return match_state.capital

func set_capital(v:int)->void:
	match_state.capital = max(v,0)

func get_legitimacy()->int:
	return match_state.legitimacy

func update_legitimacy()->void:
	var magnitude = (match_state.exploitation + match_state.alienation) * 2
	var difference:int = abs(match_state.exploitation - match_state.alienation)
	match_state.legitimacy = clamp(magnitude - 10 - difference,0,10)

func get_reaction_points()->int:
	return match_state.capital / 5

func system_generate()->void:
	set_exploitation(match_state.exploitation + match_state.alienation / 5)
	set_capital(match_state.capital + match_state.exploitation / 5)

func system_balance()->void:
	var pr:int = get_reaction_points()
	while pr > 0:
		if match_state.exploitation <= 5 or match_state.alienation <= 5:
			if match_state.exploitation < match_state.alienation:
				set_exploitation(match_state.exploitation + 1)
			elif match_state.alienation < match_state.exploitation:
				set_alienation(match_state.alienation + 1)
			else:
				set_exploitation(match_state.exploitation + 1)
				pr -= 1
				if pr <= 0:
					return
				set_alienation(match_state.alienation + 1)
		else:
			if match_state.exploitation != match_state.alienation:
				if match_state.exploitation < match_state.alienation:
					set_exploitation(match_state.exploitation + 1)
				else:
					set_alienation(match_state.alienation + 1)
			else:
				set_capital(match_state.capital + 1)
		pr -= 1

func system_turn()->void:
	system_generate()
	system_balance()
	
func _ready() -> void:
	load_player_deck()
	randomize()
	match_state.player_deck.shuffle()
