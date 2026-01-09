extends Node

func evaluate_best_hand(cards:Array)->Dictionary:
	var list = cards.duplicate()
	list.sort_custom(func(a,b): return _v(a) < _v(b))
	
	var rank_map = {}
	var suit_map = {}
	for c in list:
		var v = _v(c)
		var s = _s(c)
		rank_map[v] = rank_map.get(v,0) + 1
		suit_map[s] = suit_map.get(s,0) + 1
	
	var flush_suit = ""
	for s in suit_map:
		if suit_map[s] >= 5:
			flush_suit = s
	
	if flush_suit != "":
		var suited=[]
		for c in list:
			if _s(c)==flush_suit:
				suited.append(c)
		var sf_high = _find_straight_high(suited)
		if sf_high != -1:
			if sf_high == 13 and _has_ace(suited):
				return {"type":"royal_flush","cards":_pick_straight(suited,13)}
			return {"type":"straight_flush","cards":_pick_straight(suited,sf_high)}
	
	for v in rank_map:
		if rank_map[v] >= 4:
			return {"type":"four","cards":_pick_kind(list,v,4)}
	
	var three = -1
	var pair = -1
	for v in rank_map:
		if rank_map[v] >= 3 and v > three:
			three = v
		elif rank_map[v] >= 2 and v > pair:
			pair = v
	if three != -1 and pair != -1:
		return {"type":"full_house","cards":_pick_kind(list,three,3) + _pick_kind(list,pair,2)}
	
	if flush_suit != "":
		return {"type":"flush","cards":_pick_flush(list,flush_suit)}
	
	var straight_high = _find_straight_high(list)
	if straight_high != -1:
		return {"type":"straight","cards":_pick_straight(list,straight_high)}
	
	for v in rank_map:
		if rank_map[v] >= 3:
			return {"type":"three","cards":_pick_kind(list,v,3)}
	
	var pairs=[]
	for v in rank_map:
		if rank_map[v] >= 2:
			pairs.append(v)
	pairs.sort()
	if pairs.size() >= 2:
		return {"type":"two_pair","cards":_pick_kind(list,pairs[-1],2) + _pick_kind(list,pairs[-2],2)}
	
	if pairs.size() == 1:
		return {"type":"pair","cards":_pick_kind(list,pairs[0],2)}
	
	return {"type":"high","cards":[list[-1]]}

func _find_straight_high(cards)->int:
	var unique=[]
	for c in cards:
		var v=_v(c)
		if not unique.has(v):
			unique.append(v)
	unique.sort()
	
	var run=1
	for i in range(unique.size()-1):
		if unique[i+1]==unique[i]+1:
			run+=1
			if run>=5:
				return unique[i+1]
		else:
			run=1
	return -1

func _pick_straight(cards,high):
	var out=[]
	for i in range(cards.size()-1,-1,-1):
		if _v(cards[i])<=high and _v(cards[i])>high-5:
			out.append(cards[i])
			if out.size()==5:
				break
	return out

func _pick_flush(cards,suit):
	var out=[]
	for i in range(cards.size()-1,-1,-1):
		if _s(cards[i])==suit:
			out.append(cards[i])
			if out.size()==5:
				break
	return out

func _pick_kind(cards,value,count):
	var out=[]
	for c in cards:
		if _v(c)==value:
			out.append(c)
			if out.size()==count:
				break
	return out

func _has_ace(cards)->bool:
	for c in cards:
		if _v(c)==1:
			return true
	return false

func _v(c): return _value_to_int(c.card_name.split("_")[0])
func _s(c): return c.card_name.split("_")[1]

func _value_to_int(v:String)->int:
	if v=="ace": return 1
	if v=="j": return 11
	if v=="q": return 12
	if v=="k": return 13
	return int(v)
