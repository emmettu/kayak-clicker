extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal triggered(name)

func _ready():
	pass # Replace with function body.

func _on_Item_timeout():
	emit_signal("triggered", name)
