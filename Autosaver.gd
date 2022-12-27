extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var thread

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Autosaver_timeout():
	
	if thread.is_active():
		thread.wait_to_finish()
	thread.start(self, "save")
	
func save():
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

func _exit_tree():
	thread.wait_to_finish()
