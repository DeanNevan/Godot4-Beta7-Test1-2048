extends Control
class_name Board

signal combine_event_happend(final_value)

var scene_element : PackedScene = preload("res://src/main/element/Element.tscn")

@export var element_size : Vector2i = Vector2i(64, 64)

@export var element_gap : Vector2i = Vector2i(12, 12):
	set(_new_element_gap):
		element_gap = _new_element_gap
		arrange_elements()

@export var margin_gap : Vector2i = Vector2i(20, 20):
	set(_new_margin_gap):
		margin_gap = _new_margin_gap
		arrange_elements()

@export var is_auto_scale_element : bool = true:
	set(_new_is_auto_scale_element):
		is_auto_scale_element = _new_is_auto_scale_element
		arrange_elements()

var elements := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	init_board()
	elements[Vector2i(0, 3)].is_blank = false
	elements[Vector2i(0, 3)].change_value(2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func check_game_over() -> bool:
	var is_game_over := true
	for e in elements.values():
		if e.is_blank:
			is_game_over = false
			break
	return is_game_over

func random_new_element():
	var valid_elements := []
	for e in elements.values():
		if e.is_blank:
			valid_elements.append(e)
	var random_element : Element = valid_elements[randi() % valid_elements.size()]
	random_element.is_blank = false
	random_element.generate(2 if randi() % 2 == 0 else 4)

func get_elements_can_move(_move_direction : Vector2i) -> Array:
	var result := []
	for e in elements.values():
		var element : Element = e
		var element_to : Element = elements.get(element.position_in_board + _move_direction)
		if is_instance_valid(element_to):
			if !element.is_blank and element_to.is_blank:
				result.append(element)
	return result

func handle_move(_move_direction : Vector2i):
	await get_tree().process_frame
	
	var origin_map := {}
	for e in elements.values():
		if e.is_blank:
			origin_map[e] = 0
		else:
			origin_map[e] = e.value
	
	var combine_events := []
	
	var pairs := {}
	for x in 4:
		for y in 4:
			var pos_in_board := Vector2i(x, y)
			var element : Element = elements.get(pos_in_board)
			if element.is_blank:
				continue
			pos_in_board += _move_direction
			var is_neighbour := true
			while elements.has(pos_in_board):
				var element_to : Element = elements.get(pos_in_board)
				if !element_to.is_blank:
					if element_to.value == element.value:
						if !pairs.keys().has(element_to) and !pairs.values().has(element_to):
							pairs[element] = element_to
							emit_signal("combine_event_happend", element.value * 2)
					else:
						break
				pos_in_board += _move_direction
	
	for e in pairs:
		var element : Element = e
		var element_to : Element = pairs[e]
		element_to.change_value(element.value * 2, true)
		element.is_blank = true
		element_to.is_blank = false
		combine_events.append(element_to)
	
	var move_map := {}
	while true:
		await get_tree().create_timer(0.01).timeout
		var elements_can_move : Array = get_elements_can_move(_move_direction)
		if elements_can_move.size() == 0:
			break
		for e in elements_can_move:
			await get_tree().create_timer(0.01).timeout
			var element : Element = e
			var element_to : Element = elements.get(element.position_in_board + _move_direction)
			#move_map[element] = element_to
			if element_to.is_blank:
				element_to.is_blank = false
				element.is_blank = true
				element_to.change_value(element.value, true)
				if combine_events.has(element):
					combine_events.erase(element)
					combine_events.append(element_to)
	
	for e in combine_events:
		e.animate_zoom()
		var value = e.value
		e.value = origin_map[e]
		e.change_value(value)
	
#	for e in origin_map:
#		var element : Element = e
#		var value : int = origin_map.get(e)
#		if element.value != 0 and value != 0:
#			if element.value != value:
#				element.animate_zoom()
	
	#print("move_map: ", move_map)
	
#	for e in move_map:
#		var element : Element = e
#		var element_to : Element = move_map[e]
		

#func handle_move(_move_direction : Vector2i):
#	var move_map := {}
#	for x in 4:
#		for y in 4:
#			#print("x:%d, y:%d" % [x, y])
#			var pos_in_board := Vector2i(x, y)
#			var element : Element = elements.get(pos_in_board)
#			if element.is_blank:
#				continue
#			var element_to : Element
#			var flag_found := false
#			var flag_neighbour := true
#			var obstacles_count := 1
#			pos_in_board += _move_direction
#			while true:
#				if !elements.has(pos_in_board):
#					if is_instance_valid(element_to):
#						if element != element_to:
#							if !element.is_blank and !element_to.is_blank:
#								if element.value == element_to.value:
#									print("1")
#									move_map[element] = element_to
#							else:
#								print("2")
#								move_map[element] = element_to
#					flag_found = true
#					break
#				element_to = elements.get(pos_in_board)
#				if obstacles_count != 1 and !elements.has(pos_in_board + obstacles_count * _move_direction):
#					if !element_to.is_blank:
#						flag_found = true
#					break
#				if !element_to.is_blank:
#					if flag_neighbour:
#						if element != element_to:
#							if element.value == element_to.value:
#								print("3")
#								move_map[element] = element_to
#								flag_found = true
#								break
#							else:
#								flag_neighbour = false
#								obstacles_count += 1
#								print("!!!")
#				pos_in_board += _move_direction
#			if flag_found:
#				continue
#			if !is_instance_valid(element_to):
#				continue
#			if element != element_to:
#				print("4")
#				move_map[element] = element_to
#	print(move_map)
#	for e in move_map:
#		var element : Element = e
#		var element_to : Element = move_map[e]
#		if element_to.is_blank:
#			element.is_blank = true
#			element_to.is_blank = false
#			element_to.change_value(element.value, true)
#		else:
#			element.is_blank = true
#			element_to.change_value(element.value * 2)



func init_board():
	for x in 4:
		for y in 4:
			var new_element : Element = scene_element.instantiate()
			add_child(new_element)
			new_element.is_blank = true
			new_element.element_size = element_size
			new_element.position_in_board = Vector2i(x, y)
			elements[Vector2i(x, y)] = new_element
	arrange_elements()
	pass

func arrange_elements():
	var global_rect : Rect2i = get_global_rect()
	global_rect.position += margin_gap
	global_rect.size -= margin_gap * 2
	var global_center_pos : Vector2i = global_rect.position + global_rect.size / 2
	
	if is_auto_scale_element:
		element_size.x = (min(global_rect.size.x, global_rect.size.y) - 3 * element_gap.x) / 4
		element_size.y = (min(global_rect.size.x, global_rect.size.y) - 3 * element_gap.y) / 4
		for e in elements.values():
			e.element_size = element_size
	
	var elements_rect_size := Vector2i(
		4 * element_size.x + 3 * element_gap.x, 
		4 * element_size.y + 3 * element_gap.y
	)
	var elements_global_rect := Rect2i(
		global_center_pos - elements_rect_size / 2, 
		elements_rect_size
	)
	for x in 4:
		for y in 4:
			var element : Element = elements.get(Vector2i(x, y))
			if !is_instance_valid(element):
				print_debug("Error:arrange_elements")
				return
			element.position.x = (
				elements_global_rect.position.x + 
				element_size.x * x + 
				element_gap.x * (x - 1) + 
				element_size.x / 2
			)
			element.position.y = (
				elements_global_rect.position.y + 
				element_size.y * y + 
				element_gap.y * (y - 1) + 
				element_size.y / 2
			)
			element.element_position = element.position
	pass


func _on_resized():
	arrange_elements()
	pass # Replace with function body.
