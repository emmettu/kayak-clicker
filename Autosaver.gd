extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Autosaver_timeout():
	print("SAVING DATA")
	var shop = get_node("%Shop")
	var bank = get_node("%Bank")
	
	var unlock_tier = bank.max_unlock
	var items = shop.items
	var money = bank.money
	
	var save_file = File.new()
	save_file.open("user://save.json", File.WRITE)
	
	var save_data = {
		"items": items,
		"unlock_tier": unlock_tier,
		"money": money,
	}
	
	save_file.store_string(to_json(save_data))
	save_file.close()
