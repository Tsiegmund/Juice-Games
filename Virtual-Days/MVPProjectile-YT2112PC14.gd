extends Area2D 

var velocity = Vector2(0,0)
var speed = 300
var maxtime = 2.0

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit()
# other stuff below
	queue_free()
	

func _ready():
	connect("body_entered", self, "_on_Bullet_body_entered") 
	get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_screen_exited")
