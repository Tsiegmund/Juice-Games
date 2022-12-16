extends KinematicBody2D
class_name Actor

const bulletPath = preload("res://source/Other/Bullet.tscn")

const GRAVITY = 30
const WALK_SPEED = 200
const JUMP_SPEED = 900
var rng = RandomNumberGenerator.new()


var velocity = Vector2()

export (float) var max_health = 18
onready var health = max_health setget _set_health


func _ready():
	add_to_group("player")
	

func _physics_process(_delta):
	
	velocity.y = velocity.y + GRAVITY
	if velocity.y > 2000:
		velocity.y = 2000
	if is_on_floor():
		velocity.y = 0

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		
	if Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED
	
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		velocity.x = 0
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
		$Node2D.look_at(get_global_mouse_position())
	var label = get_node("Label")
	label.text = str(health) + "/" + str(max_health)
	move_and_slide(velocity, Vector2(0, -1))

func shoot():
	var bullet = bulletPath.instance()
	
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	var previous_position = bullet.position
	
	bullet.velocity = get_global_mouse_position() - bullet.position

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
