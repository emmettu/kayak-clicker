extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var money = 10

const CHEAPO_KAYAK = "Cheapo Kayak"
const DRIP_COFFEE = "Drip Coffee"
const ORDINARY_CUSTOMER = "Regular Guest"
const HOBBYIST_GUEST = "Hobbyist"
const COOKING_DUDE = "Cooking Dude"
const BREAKY_BURRITO = "Breaky Burrito"
const FRENCH_PRESS = "French Press"
const SPEEDY_KAYAK = "Speedy Kayak"
const CAPTAIN = "Captain"
const COFFEE_GIRL = "Coffee Girl"
const ESPRESSO = "Espresso"
const BARISTA = "Barista"
const CHEF = "Fancy Chef"
const RAMEN = "Fresh Ramen"
const ENTHUSIAST = "Yak Enthusiast"
const ADVERT = "News Advert"
const ORCA = "Orca"
const KAYAK_FACTORY = "Kayak Factory"
const SANTA = "Santa"

var max_unlock = 0
var unlock_tiers = {
	50: [DRIP_COFFEE],
	100: [BREAKY_BURRITO],
	200: [FRENCH_PRESS],
	300: [COOKING_DUDE],
	400: [HOBBYIST_GUEST],
	500: [ESPRESSO],
	600: [COFFEE_GIRL],
	800: [RAMEN],
	1000: [BARISTA],
	3000: [CAPTAIN],
	4000: [SPEEDY_KAYAK],
	8000: [CHEF],
	15000: [ENTHUSIAST],
	25000: [ADVERT],
	50000: [ORCA],
	100000: [KAYAK_FACTORY],
	200000: [SANTA],
}

signal money_updated(money, amount)

signal not_enough_money

signal item_bought(item)

signal items_unlocked(items, notify)

# Called when the node enters the scene tree for the first time.
func _ready():
	var save_file = File.new()

	if save_file.file_exists("user://save.json"):
		save_file.open("user://save.json", File.READ)
		var save_data = parse_json(save_file.get_as_text())
		save_file.close()
		money = save_data["money"]
		max_unlock = save_data["unlock_tier"]
		unlock_up_to(max_unlock, false)
	emit_signal("money_updated", money, money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Shop_money_earned(amount):
	money += amount
	unlock_up_to(money)
	emit_signal("money_updated", money, amount)


func unlock_up_to(amount, notify=true):
	var completed_tiers = []
	for tier in unlock_tiers:
		if amount >= tier:
			max_unlock = max(max_unlock, tier)
			emit_signal("items_unlocked", unlock_tiers[tier], notify)
			completed_tiers.append(tier)
			
	for tier in completed_tiers:
		unlock_tiers.erase(tier)

func _on_Shop_attempted_purchase(item, cost):
	if cost > money and cost != 0:
		emit_signal("not_enough_money")
	else:
		money -= cost
		emit_signal("money_updated", money, -cost)
		emit_signal("item_bought", item)
