extends Control
class_name Element

var ELEMENT_COLORS := {
	2    : Color.from_hsv(0.55, 0.00, 1.00),
	4    : Color.from_hsv(0.55, 0.10, 1.00),
	8    : Color.from_hsv(0.55, 0.20, 1.00),
	16   : Color.from_hsv(0.55, 0.30, 1.00),
	32   : Color.from_hsv(0.55, 0.40, 1.00),
	64   : Color.from_hsv(0.55, 0.50, 1.00),
	128  : Color.from_hsv(0.55, 0.60, 1.00),
	256  : Color.from_hsv(0.55, 0.70, 1.00),
	512  : Color.from_hsv(0.55, 0.80, 1.00),
	1024 : Color.from_hsv(0.55, 0.90, 1.00),
	2048 : Color.from_hsv(0.55, 1.00, 1.00),
}

@onready var _Value = %Value
@onready var _ValueBackground = %ValueBackground
@onready var _GridBackground = %GridBackground

var position_in_board := Vector2i(0, 0)

var value : int = 2 :
	set(_new_value):
		value = _new_value
		var tween = get_tree().create_tween()
		tween.tween_property(self, "_value_tweened", value, 0.25)

var _value_tweened = value

var element_size : Vector2i = Vector2i(64, 64):
	set(_new_element_size):
		element_size = _new_element_size
		_ValueBackground.size = element_size
		_ValueBackground.position.x = - element_size.x / 2
		_ValueBackground.position.y = - element_size.y / 2
		_ValueBackground.pivot_offset = element_size / 2
		_GridBackground.size = _ValueBackground.size
		_GridBackground.position = _ValueBackground.position
		_GridBackground.pivot_offset = _ValueBackground.pivot_offset

var is_blank := false:
	set(_new_is_blank):
		is_blank = _new_is_blank
		_GridBackground.visible = is_blank

var element_position := Vector2i()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_Value.text = str(_value_tweened)
	pass

func animate_zoom(_scale : Vector2 = Vector2(1.25, 1.25), _time : float = 0.25, _back := true):
	var origin_scale := scale
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", _scale, _time)
	if _back:
		tween.chain().tween_property(self, "scale", origin_scale, _time)

func change_value(_new_value : float, _force_change := false):
	value = _new_value
	if _force_change:
		_value_tweened = value
	update_color()

func update_color():
	if ELEMENT_COLORS.has(value):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(_ValueBackground, "modulate", ELEMENT_COLORS.get(value), 0.5)

func animate_appear():
	scale = Vector2i(0, 0)
	modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	animate_zoom(Vector2i(1, 1), 0.25, false)

func generate(_new_value : float):
	value = _new_value
	animate_appear()
	update_color()

#func animate_combine_to(_pos : Vector2i):
#	var origin_pos : Vector2i = position
#	var tween = get_tree().create_tween()
#	tween.set_trans(Tween.TRANS_CUBIC)
#	tween.set_parallel(true)
#	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
#	tween.tween_property(self, "scale", Vector2i(0, 0), 0.5)
#	tween.tween_property(self, "position", _pos, 0.5)
#	animate_zoom(Vector2i(1, 1), 0.25, false)
#	tween.tween_callback(_on_animate_combine_to_over.bind(origin_pos))
#
#func _on_animate_combine_to_over(_origin_pos : Vector2i):
#	position = _origin_pos
#	pass
#
#func animate_move_to(_pos : Vector2i):
#	var origin_pos : Vector2i = position
#	var tween = get_tree().create_tween()
#	tween.set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self, "position", _pos, 0.5)
#	tween.tween_callback(_on_animate_move_to_over.bind(origin_pos))
#
#	pass
#
#func _on_animate_move_to_over(_origin_pos : Vector2i):
#	position = _origin_pos
#	pass

