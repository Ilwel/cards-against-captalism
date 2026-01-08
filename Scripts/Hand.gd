class_name Hand
extends Node2D

const CARD_WIDTH: float = 96
const CARD_GAP: float = 8
const ROW_Y: float = 550      

var CardScene = preload("res://Scenes/Card.tscn")

func add_card(card_id) -> void:
	var card: Card = CardScene.instantiate()
	card.card_name = card_id
	add_child(card)
	reposition_cards()
	
func draw_n(n: int):
	var deck = Match.get_player_deck()
	for i in range(n):
		var card_id = deck.pop_back()
		add_card(card_id)
		await get_tree().create_timer(0.3).timeout
		
func _value_to_int(v:String)->int:
	if v == "ace": return 14
	if v == "j": return 11
	if v == "q": return 12
	if v == "k": return 13
	return int(v)
		
func sort_hand_suits()->void:
	var cards = get_children()
	
	var suit_order = ["spades","diamonds","clubs","hearts"]
	
	cards.sort_custom(func(a,b):
		var sa = a.card_name.split("_")
		var sb = b.card_name.split("_")
		
		var va = _value_to_int(sa[0])
		var vb = _value_to_int(sb[0])
		
		var ia = suit_order.find(sa[1])
		var ib = suit_order.find(sb[1])
		
		if ia == ib:
			return va > vb
		return ia > ib
	)
	
	for c in cards:
		move_child(c,get_child_count()-1)
	reposition_cards()
	
func sort_hand_rank()->void:
	var cards = get_children()
	
	cards.sort_custom(func(a,b):
		var va = _value_to_int(a.card_name.split("_")[0])
		var vb = _value_to_int(b.card_name.split("_")[0])
		return va > vb
	)
	
	for c in cards:
		move_child(c,get_child_count()-1)
	reposition_cards()

func _calc_start_x(count:int)->float:
	var screen_w := get_viewport_rect().size.x
	var total_w := count * CARD_WIDTH + (count - 1) * CARD_GAP
	return (screen_w - total_w) * 0.5 + CARD_WIDTH * 0.5
	
func reposition_cards() -> void:
	var count := get_children().size()
	if count == 0:
		return

	var start_x := _calc_start_x(count)

	for i in range(get_children().size()):
		var card = get_children()[i]
		print(card.card_name)
		var target_pos := Vector2(start_x + i * (CARD_WIDTH + CARD_GAP), ROW_Y)
		update_card_transform(card, target_pos)

func update_card_transform(card, target_pos: Vector2) -> Tween:
	target_pos = Vector2(round(target_pos.x), round(target_pos.y))
	var tween := Globals.create_smooth_tween()

	tween.tween_property(card, "global_position", target_pos, 0.15)
	return tween

func _ready() -> void:
	await draw_n(8)
	sort_hand_rank()
