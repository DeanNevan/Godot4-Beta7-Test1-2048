extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	hide()
	pass # Replace with function body.


func _on_window_settings_gui_language_selected(text):
	TranslationServer.set_locale(text)
	pass # Replace with function body.
