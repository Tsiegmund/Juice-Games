extends KinematicBody2D 

# Sets the basic speed value and velocity.
var velocity = Vector2(0,0)
var speed = 300

func _physics_process(delta):
	# Basic movement for the bullet. Move and collide lets it detect what exactly it collides with, and sets a base
	# speed for the bullet.
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)

#If it does not collide, it will run the damage code. 
	if collision_info != null:
		#If it collides with something, it will delete the bullet.
		self.queue_free()
		# When it collides, it will write the name of what it collided with. If it was the floor, it would say
		#'TileMap'. If it was the enemy, it would print 'MVPEnemy'. 
		if collision_info.collider.name == "MVPEnemy":
			# Call to the group 'enemies' and run the 'on_hit' function.
			#When it detects collision with an enemy, it will deal damage to said enemy. 
			get_tree().call_group("enemies", "_on_hit")
