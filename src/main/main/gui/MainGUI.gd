extends Control

@onready var _Board = %Board
@onready var _Score = %Score

var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TranslationServer.set_locale("en")
	update_ui()
	$WindowIntro.popup_centered()
	#$Window.child_controls_changed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var move_direction := Vector2i()
	if Input.is_action_just_pressed("move_up"):
		move_direction = Vector2i(0, -1)
	if Input.is_action_just_pressed("move_down"):
		move_direction = Vector2i(0, 1)
	if Input.is_action_just_pressed("move_left"):
		move_direction = Vector2i(-1, 0)
	if Input.is_action_just_pressed("move_right"):
		move_direction = Vector2i(1, 0)
	if move_direction != Vector2i():
		await _Board.handle_move(move_direction)
		if _Board.check_game_over():
			$PopupFail.activate(score)
		else:
			_Board.random_new_element()
	pass

func update_ui():
	_Score.text = str(score)

func _on_button_setting_pressed():
	$WindowSettings.popup_centered()
	pass # Replace with function body.


func _on_button_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_board_combine_event_happend(final_value : int):
	score += final_value
	update_ui()
	pass # Replace with function body.


func _on_window_intro_close_requested():
	$WindowIntro.hide()
	pass # Replace with function body.


func _on_button_intro_pressed():
	$WindowIntro.popup_centered()
	pass # Replace with function body.
