extends KinematicBody2D
# Setting this code as a class. This allows for other scripts to pull from this code as their own without needing to
# reiterate what has already been said. Highly important for making multiple playable characters without typing code
# again
class_name Actor

const bulletPath = preload("res://Other/Bullet.tscn")

const GRAVITY = 30
const WALK_SPEED = 200
const JUMP_SPEED = 900

var velocity = Vector2()

export (float) var max_health = 73
onready var health = max_health setget _set_health

# Setting up the basic physics. 
func _physics_process(_delta):
	# Your Y velocity will be affected by gravity, allowing the player to come back to the ground.
	velocity.y = velocity.y + GRAVITY
	# If you've been falling for a while, you will gradually speed up. This makes sure you do not go too fast and will
	# permanently cap your downwards fall at 2000.
	if velocity.y > 2000:
		velocity.y = 2000
	# If the player is currently on the floor, reset the Y velocity. This makes sure your next fall won't be instant 
	# 2000
	if is_on_floor():
		velocity.y = 0
# The player movement. Pretty self explanatory. 
	if Input.is_action_pressed("ui_left"):
		# WALK_SPEED and the others play out like a graph, hence the .x and .y at the end of most movement-specific
		# code. It plays like a graph, where the negative values are left and down and the positive values are 
		# right and up.
		velocity.x = -WALK_SPEED
		
	if Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -JUMP_SPEED
	
	# When you release your walking key, stop all your movement. This stops the player from perpetually walking in the 
	# last direction pressed.
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		velocity.x = 0
	
	# The shooting key is a custom-made keyboard input linked to left-click/
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
		# Shoot the bullet towards wherever the mouse is pointing.
		$Node2D.look_at(get_global_mouse_position())
	var label = get_node("Label")
	label.text = str(health) + "/" + str(max_health)
	move_and_slide(velocity, Vector2(0, -1))


# The shooting function.
func shoot():
	var bullet = bulletPath.instance()
	
	# Adds the bullet to the parent branch, in this case being the player.
	get_parent().add_child(bullet)
	# The bullet's spawn location is the current location of the position2D node, attached in the Bob scene.
	bullet.position = $Node2D/Position2D.global_position
	var previous_position = bullet.position
	
	bullet.velocity = get_global_mouse_position() - bullet.position

# A damage function for the player.
func damage(amount):
	_set_health(health - amount)
	
# Death function for the player.
func kill():
	pass

# Setting the health label and death conditions
func _set_health(value):
	# Previous health will be equal to the starting health
	var prev_health = health
	# 
	health = clamp(value, 0, max_health)
	# If the health no longer equals their previous health, emit a signal and update the label
	if health != prev_health:
		emit_signal("health_updated", health)
		var label = get_node("Label")
		label.text = str(health) + "/" + str(max_health)
		# If their health has hit 0, delete the enemy.
		if health == 0:
			self.queue_free()

