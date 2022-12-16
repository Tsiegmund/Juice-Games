#I return on 8/29/22

extends KinematicBody2D

const bulletPath = preload("res://source/Other/enemyProjectile.tscn")



var player = null

var attack_time = null
var attack_delay = 2
var can_shoot = true

var in_range = false


var timer = Timer.new()
var rng = RandomNumberGenerator.new()
var GRAVITY = 30
var playerPosition = Vector2.ZERO

export (float) var max_health = 100
onready var health = max_health setget _set_health

signal health_updated(health)
signal killed()

var WALK_SPEED = 200
var JUMP_SPEED = 400
var velocity = Vector2()

func _ready():
	
	add_to_group("enemies")
	
	attack_time = Timer.new()
	attack_time.set_one_shot(true)
	attack_time.set_wait_time(attack_delay)
	attack_time.connect("timeout", self, "_on_timeout_complete")
	add_child(attack_time)
func _on_timeout_complete():
	can_shoot = true
	print("time complete")
	
	
#MODE_KINEMATIC:
func _physics_process(delta):

	velocity.y = velocity.y + GRAVITY
	if is_on_floor():
		velocity.y = 0
	if velocity.y > 2000:
		velocity.y = 2000
	var state = rng.randi_range(0, 3)
	# Stay still
	if state == 0:
		timer.set_wait_time(600)
	# Right
	if state == 1:
		velocity.x = -WALK_SPEED
		timer.set_wait_time(600)
	# Left
	if state == 2:
		velocity.x = WALK_SPEED
		timer.set_wait_time(600)
		 # Jump
	if state == 3 and is_on_floor():
		velocity.y = -JUMP_SPEED
		timer.set_wait_time(5)
		
	var label = get_node("Label")
	label.text = str(health) + "/" + str(max_health)
	
	move_and_slide(velocity, Vector2(0, -1))
	
	
	

func _process(delta):
	if in_range == true:
			if can_shoot == true:
				shoot()
				can_shoot = false
				attack_time.start()

func _on_collision():
	var playerNodePath = get_parent().get_node("Bob").global_position

	var playerPosition = playerNodePath

	shoot()
	
	
func shoot():
	var bullet = bulletPath.instance()
	
	get_parent().call_deferred("add_child", bullet)
	bullet.position = $Position2D.global_position
	var previous_position = bullet.position
	
	bullet.velocity = get_parent().get_node("Bob").global_position - bullet.position 

func damage(amount):
	_set_health(health - amount)	
	
func kill():
	pass
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		var label = get_node("Label")
		label.text = str(health) + "/" + str(max_health)
		if health == 0:
			self.queue_free()

func _on_hit():
	print("confirmed Hit")
	health -= rng.randi_range(2,4)
	if health <= 0:
		queue_free()





func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		in_range = true
		

				
		


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		in_range = false
