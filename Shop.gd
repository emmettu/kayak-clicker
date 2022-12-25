extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal item_available(item)

signal new_item_bought(item, texture)

signal item_bought(item, count)

signal money_earned(amount)

signal item_triggered(name, amount)

signal attempted_purchase(item, cost)

signal item_selected(texture, description)

var item_timer = preload("res://Item.tscn")

onready var item_list = get_node("%ItemList")

const CHEAPO_KAYAK = "Cheapo Kayak"
const WOODEN_PADDLE = "Wooden Paddle"
const DIRTBAG_GUIDE = "Dirtbag Guide"
const DRIP_COFFEE = "Drip Coffee"
const ORDINARY_CUSTOMER = "Regular Guest"
const HOBBYIST_GUEST = "Hobbyist"
const COOKING_DUDE = "Cooking Dude"
const BREAKY_BURRITO = "Breaky Burrito"
const FRENCH_PRESS = "French Press"
const COFFEE_GIRL = "Coffee Girl"
const ESPRESSO = "Espresso"
const BARISTA = "Barista"
const SPEEDY_KAYAK = "Speedy Kayak"
const CHEF = "Fancy Chef"
const RAMEN = "Fresh Ramen"
const ENTHUSIAST = "Yak Enthusiast"
const ADVERT = "News Advert"
const ORCA = "Orca"

var items = {}
var timers = {}
var current_item

var kayak_texture = load("res://icons/canoe.svg")
var coffee_texture = load("res://icons/drip_coffee.svg")
var guide_texture = load("res://icons/dirtbag.svg")
var paddle_texture = load("res://icons/paddle.svg")
var ordinary_texture = load("res://icons/ordinary.svg")
var burrito_texture = load("res://icons/burrito.svg")
var dave_texture = load("res://icons/cooking_dude.svg")
var french_press_texture = load("res://icons/french_press.svg")
var espresso_texture = load("res://icons/espresso.svg")
var barista_texture = load("res://icons/barista.svg")
var hobbyist_texture = load("res://icons/hobbyist.svg")
var speed_kayak_texture = load("res://icons/kayak.svg")
var coffee_girl_texture = load("res://icons/coffee_girl.svg")
var chef_texture = load("res://icons/chef.svg")
var ramen_texture = load("res://icons/ramen.svg")
var enthusiast_texture = load("res://icons/enthusiast.svg")
var news_advert_texture = load("res://icons/news_advert.svg")
var orca_texture = load("res://icons/orca.svg")

var starting_items = [CHEAPO_KAYAK, ORDINARY_CUSTOMER]
# var starting_items = [CHEAPO_KAYAK, ORDINARY_CUSTOMER, DRIP_COFFEE, SPEEDY_KAYAK, COFFEE_GIRL, CHEF, RAMEN, ENTHUSIAST, ADVERT, ORCA, BARISTA, ESPRESSO]

const CUSTOMER_PRIORITY = [ENTHUSIAST, HOBBYIST_GUEST, ORDINARY_CUSTOMER]

const TREAT_PRIORITY = [RAMEN, ESPRESSO, FRENCH_PRESS, BREAKY_BURRITO, DRIP_COFFEE]

var periodic_costs = {
	COOKING_DUDE: 1,
	COFFEE_GIRL: 2,
	BARISTA: 3,
	CHEF: 5,
}

var item_times = {
	CHEAPO_KAYAK: 12,
	COOKING_DUDE: 10,
	SPEEDY_KAYAK: 6,
	COFFEE_GIRL: 8,
	BARISTA: 9,
	CHEF: 14,
	ADVERT: 20,
}

var customer_retention = {
	ORDINARY_CUSTOMER: 0.25,
	HOBBYIST_GUEST: 0.75,
	ENTHUSIAST: 1,
}

var item_money = {
	CHEAPO_KAYAK: 1,
	WOODEN_PADDLE: 1,
	DIRTBAG_GUIDE: 4,
	DRIP_COFFEE: 2,
	BREAKY_BURRITO: 5,
	ORDINARY_CUSTOMER: 5,
	FRENCH_PRESS: 9,
	ESPRESSO: 14,
	RAMEN: 20,
	HOBBYIST_GUEST: 10,
	ENTHUSIAST: 15,
}

var item_textures = {
	CHEAPO_KAYAK: kayak_texture,
	WOODEN_PADDLE: paddle_texture,
	DIRTBAG_GUIDE: guide_texture,
	DRIP_COFFEE: coffee_texture,
	ORDINARY_CUSTOMER: ordinary_texture,
	BREAKY_BURRITO: burrito_texture,
	COOKING_DUDE: dave_texture,
	FRENCH_PRESS: french_press_texture,
	HOBBYIST_GUEST: hobbyist_texture,
	SPEEDY_KAYAK: speed_kayak_texture,
	COFFEE_GIRL: coffee_girl_texture,
	BARISTA: barista_texture,
	ESPRESSO: espresso_texture,
	CHEF: chef_texture,
	RAMEN: ramen_texture,
	ENTHUSIAST: enthusiast_texture,
	ADVERT: news_advert_texture,
	ORCA: orca_texture,
}

var item_costs = {
	CHEAPO_KAYAK: 30,
	DRIP_COFFEE: 1,
	ORDINARY_CUSTOMER: 0,
	COOKING_DUDE: 50,
	COFFEE_GIRL: 90,
	BREAKY_BURRITO: 3,
	FRENCH_PRESS: 5,
	ESPRESSO: 8,
	HOBBYIST_GUEST: 4,
	SPEEDY_KAYAK: 200,
	RAMEN: 10,
	BARISTA: 110,
	CHEF: 150,
	ENTHUSIAST: 120,
	ADVERT: 300,
	ORCA: 1000,
}

var item_descriptions = {
	CHEAPO_KAYAK: "Cost: $30\n...OK it's actually a canoe, but you don't look like you've got money for anything fancy. Trips taken with this old thing take 15 seconds. One customer per canoe.",
	DRIP_COFFEE: "Cost: $1\nNot sure how long it's been sitting in the pot... Look your guests need coffee, it'll boost your tips by $2 per passenger.",
	ORDINARY_CUSTOMER: "Cost: Free\nHeh, this'll be my first time sea kayaking. I'll pay $4 per trip... I'm new to this though so don't expect me to come back or anything.",
	COOKING_DUDE: "Cost: $50\nHey, I'm Dave. I can cook breakfast burritos. Pay me $1 per 10 seconds and I'll make burritos for you.",
	COFFEE_GIRL: "Cost: $90\nYo, it's Sarah. I make a mean French Press. Pay me $2 per 8 seconds and I'll be your brew person.",
	BREAKY_BURRITO: "Cost: $3\nConsidering your financial situation... they're not just for breakfast, I guess. Guests will tip $5 extra if they got to enjoy one of these bad boys.",
	FRENCH_PRESS: "Cost: $5\nNow that's some good Joe. It's a bit... gritty... to match the feel of the rugged outdoors. It'll increase your tips by $9 per customer.",
	ESPRESSO: "Cost: $8\nWhat the... this tastes as good as the cities best coffee shop: The Floating Bean. It's almost... weird to serve coffee this good on a trip. It'll net a $14 bonus from each customer.",
	BARISTA: "Cost: $110\nHey dude, I quite my job at The Floating Bean cause I hear this is the new hot spot in town. For $3 every 9 seconds I'll tamp and crank my heart out to give your guests the best espresso.",
	HOBBYIST_GUEST: "Cost: $3\nYeah, I freaking love kayaking. It's literally the only thing I talk about. Follow me @ZaksInAYak1. I'll tip $10 and honestly I'll probably come back if I like this place.",
	SPEEDY_KAYAK: "Cost: $200\nOh wow, you can afford actual kayaks for your kayak store. Congratulations, I guess it's not false advertisement anymore. Trips with these things take only 6 seconds.",
	RAMEN: "Cost: $10\nThis ain't that packet stuff. Tonkatsu broth, bamboo shoots, Shoyu pork. Your guests will be going crazy for this stuff, and I'm sure the extra $20 tip won't hurt. ",
	CHEF: "Cost: $150\nNow normally I would only work for the finest restaurants, but I must admit I'm impressed by your little kayak outlet. For $5 every 14 seconds I'll serve your guests fresh ramen.",
	ENTHUSIAST: "Cost: $120\nI've paddled around the globe 3 times. Also, in case you haven't noticed I'm a literal captain. If I like a kayak place I'll come back everytime, which means I'll pay $15 everytime.",
	ADVERT: "Cost: $300\nOh wow, we're advertising now? This is serious, I hope you're ready for all this fame. Every 20 seconds you'll get a new random customer.",
	ORCA: "Cost: $1000\nWait wait wait, you're buying literal WHALES now? Is that- is that humane? I have no idea. Each orca has a 10% chance to be spotted per trip. Triples tip money.",
}

var rng = RandomNumberGenerator.new()

func _ready():
	
	for i in starting_items:
		emit_signal("item_available", i)
	
	_on_Bank_item_bought(CHEAPO_KAYAK)
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_selected(index):
	
	var item = item_list.get_item_text(index)
	emit_signal("item_selected", item_textures[item], item_descriptions[item])
	current_item = item
	"""
	Engine ideas
	- Advertisement generates customers, customers generate tips, coffee + treats modify customer tips
	- Customers generate money
	- Kayaks + paddles reduce trip timer so tips proc faster
	- Guides take money, generate tips from customers
	- Orcas have a non guaranteed chance to multiply tips, eg. 10 orcas, 33% chance to see each orca
	- Merch shop generates money per t-shirt
	- xFrench Press, Espresso
	- xHobbyist Guest, Fancy Guest, Intense Kayaker
	- xBreaky Buritto, Fresh ramen
	- xCooking Guy, Fancy Chef
	- Dirtbag Guide, Experienced Guide
	- Coffee Girl, Barista, 
	- Orcas, narwhales
	"""
	
func _on_Item_triggered(name):
	# var amount = item_money[name] * items[name]
	var cindex = 0; var kindex = 0
	
	if name.ends_with("Kayak"):
		var customers_served = {}
		var kayak_count = items[name]
		var treats_needed = 0
		for customer_type in CUSTOMER_PRIORITY:
			customers_served[customer_type] = 0
			if not customer_type in items or items[customer_type] < 1:
				continue
			var customer_type_count = items[customer_type]
			if customer_type_count < kayak_count:
				customers_served[customer_type] += customer_type_count
				treats_needed += customer_type_count
				kayak_count -= customer_type_count
			else:
				customers_served[customer_type] = kayak_count
				treats_needed += kayak_count
				kayak_count = 0
		
		var trip_money = 0
		for treat_type in TREAT_PRIORITY:
			if treat_type in items and items[treat_type] > 0 and treats_needed > 0:
				var treats_used = min(items[treat_type], treats_needed)
				treats_needed -= treats_used
				items[treat_type] -= treats_used
				trip_money += treats_used * item_money[treat_type]
				emit_signal("item_bought", treat_type, items[treat_type])
				emit_signal("item_triggered", treat_type, treats_used)
			
		for customer_type in customers_served:
			if customers_served[customer_type] < 1:
				continue
				
			var customers_retained = floor(customer_retention[customer_type] * customers_served[customer_type])
			print("RETAINED: ", customers_retained)
			items[customer_type] -= customers_served[customer_type]
			items[customer_type] += customers_retained
			trip_money += item_money[customer_type] * customers_served[customer_type]
			
			emit_signal("item_triggered", customer_type, customers_served[customer_type])
			emit_signal("item_triggered", name, customers_served[customer_type])
			emit_signal("item_bought", customer_type, items[customer_type])
		
		if ORCA in items:
			var orca_count = items[ORCA]
			var chance = 0.1 * orca_count
			if rng.randf() < chance:
				emit_signal("item_triggered", ORCA, orca_count)
				trip_money *= 3
		
		emit_signal("money_earned", trip_money)
		
	elif name == COOKING_DUDE:
		emit_signal("money_earned", -periodic_costs[name] * items[name])
		emit_signal("item_triggered", name, items[name])
		_on_Bank_item_bought(BREAKY_BURRITO, items[name])
		
	elif name == COFFEE_GIRL:
		emit_signal("money_earned", -periodic_costs[name] * items[name])
		emit_signal("item_triggered", name, items[name])
		_on_Bank_item_bought(FRENCH_PRESS, items[name])
	
	elif name == BARISTA:
		emit_signal("money_earned", -periodic_costs[name] * items[name])
		emit_signal("item_triggered", name, items[name])
		_on_Bank_item_bought(ESPRESSO, items[name])
		
	elif name == CHEF:
		emit_signal("money_earned", -periodic_costs[name] * items[name])
		emit_signal("item_triggered", name, items[name])
		_on_Bank_item_bought(RAMEN, items[name])
		
	elif name == ADVERT:
		emit_signal("item_triggered", name, items[name])
		var customer_type = CUSTOMER_PRIORITY[rng.randi() % len(CUSTOMER_PRIORITY)]
		_on_Bank_item_bought(customer_type, items[name])
	# emit_signal("item_triggered", name, customers_served[])


func _on_Bank_item_bought(item, amount=1):
	print("ITEM BOUGHT :D")
	if item in items:
		items[item] += amount
		emit_signal("item_bought", item, items[item])
	else:
		items[item] = amount
		emit_signal("new_item_bought", item, item_textures[item])
		
		if item in item_times:
			var timer = item_timer.instance()
			timer.name = item
			timers[name] = timer
		
			timer.connect("triggered", self, "_on_Item_triggered")
		
			add_child(timer)
			timer.start(item_times[item])



func _on_BuyButton_pressed():
	if current_item:
		emit_signal("attempted_purchase", current_item, item_costs[current_item])


func _on_Bank_items_unlocked(items):
	for i in items:
		emit_signal("item_available", i)
