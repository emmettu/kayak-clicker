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
const COFFEE_GIRL = "Coffee Girl"
const ESPRESSO = "Espresso"
const BARISTA = "Barista"
const CHEF = "Fancy Chef"
const RAMEN = "Fresh Ramen"
const ENTHUSIAST = "Yak Enthusiast"
const ADVERT = "News Advert"
const ORCA = "Orca"
const SANTA = "Santa"

var unlock_tiers = {
	50: [DRIP_COFFEE],
	100: [BREAKY_BURRITO],
	200: [FRENCH_PRESS, COOKING_DUDE],
	400: [HOBBYIST_GUEST, ESPRESSO],
	600: [COFFEE_GIRL, RAMEN],
	1000: [BARISTA],
	1200: [SPEEDY_KAYAK],
	1500: [CHEF],
	3000: [ENTHUSIAST],
	8000: [ADVERT],
	12000: [ORCA],
	25000: [SANTA],
}

signal money_updated(money, amount)

signal not_enough_money

signal item_bought(item)

signal items_unlocked(items)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("money_updated", money, money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Shop_money_earned(amount):
	money += amount
	for tier in unlock_tiers:
		if money >= tier:
			emit_signal("items_unlocked", unlock_tiers[tier])
			unlock_tiers.erase(tier)
	emit_signal("money_updated", money, amount)


func _on_Shop_attempted_purchase(item, cost):
	if cost > money and cost != 0:
		emit_signal("not_enough_money")
	else:
		money -= cost
		emit_signal("money_updated", money, -cost)
		emit_signal("item_bought", item)
