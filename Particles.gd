extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var particle_pool = []
export var pool_size = 4

export var texture: Texture setget set_texture, get_texture
export var amount = 1 setget set_amount, get_amount
# Called when the node enters the scene tree for the first time.
func _ready():
	var base = $Particle
	particle_pool.append(base)
	base.texture = texture
	print("CURRENT TEXTURE is", texture)
	print("AMOUNT is", amount)
	for i in pool_size - 1:
		var particle = base.duplicate()
		particle_pool.append(particle)
		add_child(particle)

func get_texture():
	return particle_pool[0].texture

func set_texture(new_texture):
	texture = new_texture
	for p in particle_pool:
		p.texture = texture
		
func set_amount(new_amount):
	amount = new_amount
	
func get_amount():
	return amount
	
func emit():
	var next_particle = particle_pool.pop_back()
	next_particle.amount = amount
	next_particle.emitting = true
	
	particle_pool.push_front(next_particle)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
