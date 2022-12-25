extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var text = "" setget set_text, get_text
export var font_color: Color setget set_font_color, get_font_color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_text(text):
	$Label.text = text

func get_text():
	return $Label.text
	
func set_font_color(color):
	$Label.add_color_override("font_color", color)

func get_font_color():
	return $Label.get_color("font_color")

func _on_Timer_timeout():
	hide()

func _on_Bank_items_unlocked(items, notify):
	if notify:
		popup_centered_minsize()
		$Timer.start()


func _on_Bank_not_enough_money():
	popup_centered_minsize()
	$Timer.start()
