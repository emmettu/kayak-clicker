extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("I'm READY NOW")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Shop_item_available(item):
	print("GOT ITEM!")
	add_item(item)
	print(items[0])
