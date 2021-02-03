extends KinematicBody

export var moveto = Vector3()
var stop = false


func _physics_process(delta):
	if !stop:
		var col = move_and_collide(moveto * 2)
		if col:
			stop = true
			print("bonk")
