extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_PARTICLES = 20
onready var particles = $Particles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bank_money_updated(money, amount):
	text = "Money: $" + str(money)
	if money != amount and amount > 0:
		particles.amount = min(MAX_PARTICLES, floor(amount / 10) + 1)
		particles.emit()
