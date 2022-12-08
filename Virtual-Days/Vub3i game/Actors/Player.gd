
extends Actor

# Setting basic movement for the current MVP player
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y -= 1
	if Input.is_action_pressed("up") and Input.is_action_pressed("left") and is_on_floor():
		velocity.y -= 1
		velocity.x -= 1
	if Input.is_action_pressed("up") and Input.is_action_pressed("right") and is_on_floor():
		velocity.y -= 1
		velocity.x += 1
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
