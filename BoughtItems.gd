extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var item_panel = preload("res://ItemPanel.tscn")
onready var shop = get_node("%Shop")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Shop_new_item_bought(item, texture, count=1):
	var panel = item_panel.instance()
	panel.name = item
	add_child(panel)
	panel.set_name(item)
	panel.set_icon(texture)
	panel.set_count(count)
	shop.connect("item_triggered", panel, "_on_Shop_item_triggered")
	


func _on_Shop_item_bought(item, count):
	var node = get_node(item)
	node.set_count(count)


func _on_BoughtItems_resized():
	columns = floor((get_viewport_rect().size.x - 240) / 150)
