extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal item_available(item)

signal new_item_bought(item, texture, amount)

signal item_bought(item, count)

signal money_earned(amount)

signal item_triggered(name, amount)

signal attempted_purchase(item, cost)

signal item_selected(texture, description)

var item_timer = preload("res://Item.tscn")

onready var item_list = get_node("%ItemList")

const CHEAPO_KAYAK = "Cheapo Kayak"
const DIRTBAG_GUIDE = "Dritbag Guide"
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
const SANTA = "Santa"

var items = {}
var timers = {}
var current_item

var kayak_texture = load("res://icons/canoe.svg")
var coffee_texture = load("res://icons/drip_coffee.svg")
var ordinary_texture = load("res://icons/ordinary.svg")
var dirtbag_texture = load("res://icons/dirtbag.svg")
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
var santa_texture = load("res://icons/santa.svg")

var starting_items = [CHEAPO_KAYAK, ORDINARY_CUSTOMER, DIRTBAG_GUIDE]
# var starting_items = [CHEAPO_KAYAK, ORDINARY_CUSTOMER, DRIP_COFFEE, SPEEDY_KAYAK, COFFEE_GIRL, CHEF, RAMEN, ENTHUSIAST, ADVERT, ORCA, BARISTA, ESPRESSO]

const CUSTOMER_PRIORITY = [SANTA, ENTHUSIAST, HOBBYIST_GUEST, ORDINARY_CUSTOMER]

const FOOD_PRIORITY = [RAMEN, BREAKY_BURRITO]
const COFFEE_PRIORITY = [ESPRESSO, FRENCH_PRESS, DRIP_COFFEE]

const GUIDE_PRIORITY = [DIRTBAG_GUIDE]

var guide_capacity = {
	DIRTBAG_GUIDE: 10,
}

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
	SANTA: 1,
}

var item_money = {
	CHEAPO_KAYAK: 1,
	DRIP_COFFEE: 2,
	BREAKY_BURRITO: 5,
	ORDINARY_CUSTOMER: 4,
	FRENCH_PRESS: 9,
	ESPRESSO: 14,
	RAMEN: 20,
	HOBBYIST_GUEST: 10,
	ENTHUSIAST: 15,
	SANTA: 500,
}

var item_textures = {
	CHEAPO_KAYAK: kayak_texture,
	DRIP_COFFEE: coffee_texture,
	ORDINARY_CUSTOMER: ordinary_texture,
	DIRTBAG_GUIDE: dirtbag_texture,
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
	SANTA: santa_texture,
}

var item_costs = {
	CHEAPO_KAYAK: 30,
	DRIP_COFFEE: 1,
	ORDINARY_CUSTOMER: 0,
	DIRTBAG_GUIDE: 50,
	COOKING_DUDE: 50,
	COFFEE_GIRL: 90,
	BREAKY_BURRITO: 3,
	FRENCH_PRESS: 5,
	ESPRESSO: 8,
	HOBBYIST_GUEST: 7,
	SPEEDY_KAYAK: 200,
	RAMEN: 10,
	BARISTA: 110,
	CHEF: 150,
	ENTHUSIAST: 120,
	ADVERT: 300,
	ORCA: 1000,
	SANTA: 10000,
}

var item_descriptions = {
	CHEAPO_KAYAK: "Cost: $30\n...OK it's actually a canoe, but you don't look like you've got money for anything fancy. Trips taken with this old thing take 15 seconds. One customer per canoe.",
	DRIP_COFFEE: "Cost: $1\nNot sure how long it's been sitting in the pot... Look your guests need coffee, it'll boost your tips by $2 per passenger.",
	ORDINARY_CUSTOMER: "Cost: Free\nHeh, this'll be my first time sea kayaking. I'll pay $4 per trip... I'm new to this though, so don't expect me to come back or anything.",
	DIRTBAG_GUIDE: "Cost: $50\nACSKG? Is that a science thing or something? Look just pay me $1 per 10 seconds and I'll run kayak trips for you.",
	COOKING_DUDE: "Cost: $50\nHey, I'm Dave. I can cook breakfast burritos. Pay me $1 per 10 seconds and I'll make burritos for you.",
	COFFEE_GIRL: "Cost: $90\nYo, it's Sarah. I make a mean French Press. Pay me $2 per 8 seconds and I'll be your brew person.",
	BREAKY_BURRITO: "Cost: $3\nConsidering your financial situation... they're not just for breakfast, I guess. Guests will tip $5 extra if they get to enjoy one of these bad boys.",
	FRENCH_PRESS: "Cost: $5\nNow that's some good Joe. It's a bit... gritty... to match the feel of the rugged outdoors. It'll increase your tips by $9 per customer.",
	ESPRESSO: "Cost: $8\nWhat the... this tastes just as good as the city's best coffee shop: The Floating Bean. Isn't it a bit... weird to serve coffee this good on a KAYAKING trip? It'll net a $14 bonus from each customer.",
	BARISTA: "Cost: $110\nHey dude, I quite my job at The Floating Bean cause I hear this is the new hot spot in town. For $3 every 9 seconds I'll tamp and crank my heart out to give your guests the best espresso.",
	HOBBYIST_GUEST: "Cost: $7\nYeah, I freaking love kayaking. It's literally the only thing I talk about. Follow me @ZaksInAYak1. I'll tip $10, and honestly I'll probably come back if I like this place.",
	SPEEDY_KAYAK: "Cost: $200\nOh wow, you can afford actual kayaks for your kayak outlet, congratulations. I guess it's not false advertisement anymore. These cut through the water so well that trips take only 6 seconds with them.",
	RAMEN: "Cost: $10\nThis ain't that packet stuff. Tonkatsu broth, bamboo shoots, Shoyu pork. Your guests will be going crazy for a bowl, and I'm sure the extra $20 tip won't hurt. ",
	CHEF: "Cost: $150\nNow normally I would only work for the finest restaurants, but I must admit I'm impressed by your little kayak outlet. For $5 every 14 seconds I'll serve your guests fresh ramen.",
	ENTHUSIAST: "Cost: $120\nI've paddled around the globe 3 times. Also, in case you haven't noticed I'm a literal ship captain. If I like a kayak place I'll come back everytime, which means I'll pay $15 everytime.",
	ADVERT: "Cost: $300\nOh wow, you're advertising now? This is serious, I hope you're ready for all the fame. Every 20 seconds you'll get a new random customer.",
	ORCA: "Cost: $1,000\nWait wait wait, you're buying literal WHALES now? Is that- is that humane? I have no idea. Each orca has a 10% chance to be spotted per trip. Triples tip money.",
	SANTA: "Cost: $10,000\nHo Ho Ho! Merry Christmas, and congratulations on rebuilding this business! Santa loves capitalism! I'd love to go for a trip myself you know, and if you've been good there's $500 in it for you.",
}

var rng = RandomNumberGenerator.new()

func _ready():
	var save_file = File.new()

	if save_file.file_exists("user://save.json"):
		save_file.open("user://save.json", File.READ)
		var save_data = parse_json(save_file.get_as_text())
		save_file.close()
		var saved_items = save_data["items"]
		for i in saved_items:
			_on_Bank_item_bought(i, saved_items[i])
		for i in starting_items:
			emit_signal("item_available", i)
		items = saved_items
	else:
		for i in starting_items:
			emit_signal("item_available", i)
	
		_on_Bank_item_bought(CHEAPO_KAYAK)
		_on_Bank_item_bought(DIRTBAG_GUIDE)
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
	
	if name.ends_with("Kayak"):
		var customers_served = {}
		var guide_capacity_remaining = {}
		var kayak_count = items[name]
		var customers_left = {}
		var total_served = 0
		var trip_money = 0
		
		for guide_type in GUIDE_PRIORITY:
			guide_capacity_remaining[guide_type] = items.get(guide_type, 0) * guide_capacity[guide_type]
			
		for customer_type in CUSTOMER_PRIORITY:
			customers_left[customer_type] = items.get(customer_type, 0)
			
		var guide_index = 0; var customer_index = 0
		while guide_index < len(GUIDE_PRIORITY) and customer_index < len(CUSTOMER_PRIORITY) and kayak_count > 0:
			var guide_type = GUIDE_PRIORITY[guide_index]
			var customer_type = CUSTOMER_PRIORITY[customer_index]
			
			var used = [guide_capacity_remaining[guide_type], customers_left[customer_type], kayak_count].min()
			
			guide_capacity_remaining[guide_type] -= used
			kayak_count -= used
			customers_left[customer_type] -= used
			total_served += used
			
			if customers_left[customer_type] <= 0:
				customer_index += 1
			if guide_capacity_remaining[guide_type] <= 0:
				guide_index += 1
			
#		for customer_type in CUSTOMER_PRIORITY:
#			customers_served[customer_type] = 0
#			if not customer_type in items or items[customer_type] < 1:
#				continue
#			var customer_type_count = items[customer_type]
#			if customer_type_count < kayak_count:
#				customers_served[customer_type] += customer_type_count
#				treats_needed += customer_type_count
#				kayak_count -= customer_type_count
#			else:
#				customers_served[customer_type] = kayak_count
#				treats_needed += kayak_count
#				kayak_count = 0
		
		var coffee_needed = total_served
		var food_needed = total_served
		for coffee_type in COFFEE_PRIORITY:
			if coffee_type in items and items[coffee_type] > 0 and coffee_needed > 0:
				var coffee_used = min(items[coffee_type], coffee_needed)
				coffee_needed -= coffee_used
				items[coffee_type] -= coffee_used
				trip_money += coffee_used * item_money[coffee_type]
				emit_signal("item_bought", coffee_type, items[coffee_type])
				emit_signal("item_triggered", coffee_type, coffee_used)
				
		for food_type in FOOD_PRIORITY:
			if food_type in items and items[food_type] > 0 and food_needed > 0:
				var food_used = min(items[food_type], food_needed)
				food_needed -= food_used
				items[food_type] -= food_used
				trip_money += food_used * item_money[food_type]
				emit_signal("item_bought", food_type, items[food_type])
				emit_signal("item_triggered", food_type, food_used)
			
		for customer_type in customers_left:
			var served = items.get(customer_type, 0) - customers_left[customer_type]
			if served < 1:
				continue
				
			var customers_retained = floor(customer_retention[customer_type] * served)
			print("RETAINED: ", customers_retained)
			items[customer_type] -= served
			items[customer_type] += customers_retained
			trip_money += item_money[customer_type] * served
			
			emit_signal("item_triggered", customer_type, served)
			emit_signal("item_bought", customer_type, items[customer_type])
		
		
		if total_served > 0:
			emit_signal("item_triggered", name, items[name] - kayak_count)
		
		
		for guide_type in guide_capacity_remaining:
			var capacity = guide_capacity[guide_type] * items.get(guide_type, 0)
			var capacity_used = capacity - guide_capacity_remaining[guide_type]
			var guides_used = ceil(capacity_used / guide_capacity[guide_type])
			if guides_used < 1:
				continue
				
			print(guide_type, " CAPACITY OF ", capacity, " we used ", capacity_used, " therefore ", guides_used, " guides were used")
			
			emit_signal("item_triggered", guide_type, guides_used)
			
		if ORCA in items and total_served > 0:
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
		emit_signal("new_item_bought", item, item_textures[item], amount)
		
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


func _on_Bank_items_unlocked(new_items, _notify):
	for i in new_items:
		emit_signal("item_available", i)
