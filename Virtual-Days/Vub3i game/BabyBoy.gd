#timer += delta
#print(timer)
#if timer > wait_time:
#	timer = 0
#	emit_signal("timeout")


extends KinematicBody2D

# Signal for the health being updated and the enemy dying
signal health_updated(health)
signal killed()
signal timeout

# Setting the moving_left to true to start the enemy's movement in a direction we want and setting up a random
# number generator
var is_moving_left = true
var rng = RandomNumberGenerator.new()
var time = 0
var TIME_PERIOD = 3

# Setting enemy gravity, velocity, and max health
var gravity = 10
var velocity = Vector2(0, 0)
export (float) var max_health = 64

# Setting up the health and invulnerability.
onready var health = max_health setget _set_health
onready var is_invulnerable = false

# Previous health method, used for making the label
# Basic speed stat
var prev_health = 100
var speed = 32

#Adds BabyBoy to the 'enemies' group and plays his walking animation
func _ready():
	add_to_group("enemies")
	$AnimationPlayer.play("Walk")

# Allows BabyBoy to move, turn around, and set up his label.
func _process(delta):
	move_character()
	detect_turn_around()
	var label = get_node("Label")
	label.text = str(health) + "/" + str(max_health)
	move_and_slide(velocity, Vector2(0, -1))
	
	time += delta
	if time > TIME_PERIOD:
		emit_signal("timeout")
		is_invulnerable = false
		time = 0

# Move left if they are facing left, otherwise make them move right.
# Adds basic gravity
func move_character():
	velocity.x = -speed if is_moving_left else speed
	velocity.y += gravity
	
	# Basic velocity for the enemy.
	velocity = move_and_slide(velocity, Vector2.UP)
# Sets up the turn-around detection
func detect_turn_around():
	# If the raycast is not collliding with anything (empty space) and the enemy is on the floor, change the movement direction.
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

# Damage function. When hit, deal the set amount of damage from the total health. If they are invulnerable, do nothing.
func damage(amount):
		_set_health(health - amount)
		print("Damage taken!")

	
# If the kill function is called, then pass
func kill():
	pass
	
func _on_hit():
	# When the bullet has hit the enemy, it will choose a random integer between XXX and XXX to deal to the enemy.
	_process(0)
	if !is_invulnerable:
		health -= rng.randi_range(2,4)
		is_invulnerable = true
	else:
		print("Invulnerability is still up!")
	# A failsafe for the previous death function. If their health hits zero, delete the enemy
	if health <= 0:
		queue_free()

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

# Setting up the bullet's damage and a backup enemy kill
