extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var name_label = get_node("%NameLabel")
onready var count_label = get_node("%CountLabel")
onready var icon = get_node("%Icon")

var particle_scene = preload("res://Particle.tscn")
onready var particles = get_node("%Particles")

const MAX_PARTICLES = 20

# onready var n_label = $CenterContainer/GridContainer/MarginContainer/NameLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	# particles = particle_scene.instance()
	pass

func set_icon(texture):
	icon.texture = texture
	# var particles = particle_scene.instance()
	# icon.add_child(particles)
	particles.texture = texture

	
func set_name(name):
	name_label.text = name
	
func set_count(count):
	count_label.text = str(count)
	particles.amount = min(MAX_PARTICLES, count)
	
func _on_Shop_item_triggered(item_name, amount):
	if item_name == name:
		particles.amount = amount
		particles.emit()
		print(item_name, " TRIGGERED!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
