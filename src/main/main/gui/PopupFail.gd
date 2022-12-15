extends PopupPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate(_score : int):
	$MarginContainer/Label.text = tr("!fail_text") % str(_score)
	popup_centered()
