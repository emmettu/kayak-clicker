extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const CHEAPO_KAYAK = "Cheapo Kayak"

const ORDINARY_CUSTOMER = "Ordinary Customer"

const KAYAK_PRIORITY = [CHEAPO_KAYAK]

const CUSTOMER_PRIORITY = [ORDINARY_CUSTOMER]

signal trip_over(supplies)

var kayak_times = {
	CHEAPO_KAYAK: 15,
}

var supplies
var trip_time
var trip_supplies

# Called when the node enters the scene tree for the first time.
func _ready():
	var cindex = 0; var kindex = 0
	
	var trip_supplies = {}
	
	while cindex < len(CUSTOMER_PRIORITY) and kindex < len(KAYAK_PRIORITY):
		var current_kayaks = KAYAK_PRIORITY[kindex]
		var current_customers = CUSTOMER_PRIORITY[cindex]
		
		var customer_count = supplies[current_customers]
		var kayak_count = supplies[current_kayaks]
		
		if customer_count > kayak_count:
			trip_supplies[current_kayaks] += kayak_count
			supplies[current_kayaks] -= kayak_count
			trip_supplies[current_customers] += kayak_count
			supplies[current_customers] -= kayak_count
			kindex += 1
		elif customer_count == kayak_count:
			trip_supplies[current_kayaks] += kayak_count
			supplies[current_kayaks] -= kayak_count
			trip_supplies[current_customers] += kayak_count
			supplies[current_customers] -= kayak_count
			kindex += 1
			cindex += 1
		else:
			trip_supplies[current_kayaks] += customer_count
			supplies[current_kayaks] -= customer_count
			trip_supplies[current_customers] += customer_count
			supplies[current_customers] -= customer_count
			cindex += 1
			
	for k in KAYAK_PRIORITY:
		if k in trip_supplies:
			wait_time = kayak_times[k]
	print("TRIP TIME IS: ", wait_time)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Trip_timeout():
	for item in trip_supplies:
		supplies[item] += trip_supplies[item]
		
	emit_signal("trip_over", trip_supplies)
	print("TRIP OVER, FREEING NOW.")
	free()
		
