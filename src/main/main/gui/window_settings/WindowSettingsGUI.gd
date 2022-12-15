extends MarginContainer

signal language_selected(text)

@onready var _OptionButton = %OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	var text : String = _OptionButton.get_item_text(index)
	emit_signal("language_selected", text)
	pass # Replace with function body.
