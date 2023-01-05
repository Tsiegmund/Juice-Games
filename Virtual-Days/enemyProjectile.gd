extends KinematicBody2D 



var velocity = Vector2(0,0)
var speed = 300

func _physics_process(delta):
	
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

	if collision_info != null:
		print(collision_info.collider.name)
		self.queue_free()
		if collision_info.collider.name == "Bob":
			get_tree().call_group("player", "_on_hit")
		if collision_info.collider.name == "MVPEnemy":
			get_tree().call_group("enemies", "_on_hit")
			self.queue_free()
